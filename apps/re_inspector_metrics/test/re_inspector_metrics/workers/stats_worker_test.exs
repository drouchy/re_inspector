defmodule ReInspector.Metrics.StatsWorker do
  use ExUnit.Case
  import Mock

  alias ReInspector.Metrics.Workers.StatsWorker
  alias ReInspector.Metrics.Statman

  @path "/test"
  @total 100268
  @from  {1414, 323752, 827739 }
  @to    {1414, 323752, 928007 }

  # handle_cast web_transaction
  test "it replies with an OTP compatible value" do
    {:noreply, :state} = StatsWorker.handle_cast({:web_transaction, [path: @path, total: @total]}, :state)
  end

  test_with_mock "it sends the total in statman", Statman, statman_mock do
    StatsWorker.handle_cast({:web_transaction, [path: @path, total: @total]}, :state)

    assert called Statman.histogram({@path, :total}, @total)
  end

  test "it supports cast with from & to form" do
    {:noreply, :state} = StatsWorker.handle_cast({:web_transaction, [path: @path, from: @from, to: @to]}, :state)
  end

  test_with_mock "it computes the elapsed time", Statman, statman_mock do
    StatsWorker.handle_cast({:web_transaction, [path: @path, from: @from, to: @to]}, :state)

    assert called Statman.histogram({@path, :total}, @total)
  end

  defp statman_mock do
    [
      histogram: fn({@path, :total}, @total) -> :ok end
    ]
  end
end
