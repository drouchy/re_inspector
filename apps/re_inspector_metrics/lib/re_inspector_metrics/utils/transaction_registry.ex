defmodule ReInspector.Metrics.TransactionRegistry do
  @transaction_id_key "metrics.transaction_id"
  import Logger

  def start_link do
    Logger.debug fn -> "stating the transaction registry" end
    Agent.start_link(fn -> HashDict.new end, name: :transactions)
  end

  def register_new_transaction(name) do
    transaction_id = generate_id
    Logger.debug fn -> "registing new transaction #{name} -> #{transaction_id}" end
    Process.put(@transaction_id_key, transaction_id)
    store_value(transaction_id, name)
    { :ok, transaction_id }
  end

  def terminate_transaction(transaction_id) do
    remove_entry(transaction_id)
    Process.delete(@transaction_id_key)
    :ok
  end

  def current_transaction do
    Logger.debug fn -> "requesting current transaction" end
    case Process.get(@transaction_id_key) do
      nil   -> :none
      value -> value
    end
  end

  def transaction_name(transaction_id) do
    Logger.debug fn -> "searching transaction name for '#{transaction_id}'" end
    case get_value(transaction_id) do
      nil   -> { :error , :not_found }
      value -> { :ok, value }
    end
  end

  defp generate_id, do: :crypto.rand_bytes(15) |> Base.encode64

  defp store_value(key, value), do: Agent.update(:transactions, &HashDict.put(&1, key, value))
  defp get_value(key), do:          Agent.get(:transactions, &HashDict.get(&1, key))
  defp remove_entry(key), do:       Agent.update(:transactions, &HashDict.delete(&1, key))
end
