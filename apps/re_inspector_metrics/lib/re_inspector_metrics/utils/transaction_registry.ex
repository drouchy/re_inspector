defmodule ReInspector.Metrics.TransactionRegistry do
  @transaction_id_key "metrics.transaction_id"
  import Logger

  def current_transaction(transaction_id) do
    Process.put(@transaction_id_key, transaction_id)
    :ok
  end

  def current_transaction do
    Logger.debug fn -> "requesting current transaction #{inspect Process.get(@transaction_id_key)}" end
    case Process.get(@transaction_id_key) do
      nil            -> :none
      transaction_id -> transaction_id
    end
  end

end
