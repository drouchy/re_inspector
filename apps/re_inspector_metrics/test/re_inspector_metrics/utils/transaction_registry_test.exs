defmodule ReInspector.Metrics.TransactionRegistryTest do
  use ExUnit.Case

  alias ReInspector.Metrics.TransactionRegistry

  @path "/tmp/path"

  # current_transaction/1
  test "it return :ok" do
    :ok = TransactionRegistry.current_transaction(@path)
  end

  test "it registers the transaction in the process" do
    TransactionRegistry.current_transaction(@path)

    assert Process.get("metrics.transaction_id") == @path
  end

  # current_transaction/0
  test "it returns :none if nothing is registered" do
    :none = TransactionRegistry.current_transaction
  end

  test "it returns the transaction name previously registered" do
    TransactionRegistry.current_transaction(@path)

    assert TransactionRegistry.current_transaction == @path
  end

  test "it does not return the value for an other process" do
    TransactionRegistry.current_transaction(@path)

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
end
