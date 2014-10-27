defmodule ReInspector.Metrics.TransactionRegistryTest do
  use ExUnit.Case

  alias ReInspector.Metrics.TransactionRegistry

  @path "/tmp/path"

  # register_new_transaction/1
  test "it returns a id" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    assert transaction_id != nil
  end

  test "it returns an unique id every time" do
    transactions = Enum.map(1..1000, fn x ->
      { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)
      transaction_id
    end) |> Enum.uniq

    assert Enum.count(transactions) == 1000
  end

  test "it stores the transaction id in the cache" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    from_agent = Agent.get(:transactions, &HashDict.get(&1, transaction_id))

    assert from_agent == @path
  end

  # current_transaction/0
  test "it returns :none if nothing is registered" do
    :none = TransactionRegistry.current_transaction
  end

  test "it returns the transaction id previously registered" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    assert TransactionRegistry.current_transaction == transaction_id
  end

  test "it does not return the value for an other process" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    pid = self()
    spawn fn ->
      send pid, {:transaction_id , TransactionRegistry.current_transaction }
    end

    receive do
      {:transaction_id, :none} -> :ok
      _                        -> raise "invalid transaction id"
    after
      100 -> raise "did not receive the transaction id"
    end
  end

  # terminate_transaction/1
  test "removes the transaction from the memory" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    :ok = TransactionRegistry.terminate_transaction(transaction_id)

    { :error, :not_found } = TransactionRegistry.transaction_name(transaction_id)
  end

  test "removes the transaction from the current transaction" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    :ok = TransactionRegistry.terminate_transaction(transaction_id)

    :none = TransactionRegistry.current_transaction
  end

  test "does not do anything if there is no such transaction id" do
    :ok = TransactionRegistry.terminate_transaction("not-an-id")
  end

  # transaction_name/0
  test "it returns the name of the transation registered with the id" do
    { :ok, transaction_id } = TransactionRegistry.register_new_transaction(@path)

    { :ok, @path } = TransactionRegistry.transaction_name(transaction_id)
  end

  test "it returns :not_found if it can't find a transaction" do
    { :error, :not_found } = TransactionRegistry.transaction_name("an id")
  end
end
