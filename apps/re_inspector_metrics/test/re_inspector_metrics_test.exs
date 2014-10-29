defmodule ReInspector.MetricsTest do
  use ExUnit.Case
  import Mock

  #register_web_transaction/2
  test_with_mock "cast a message for processing", GenServer,
  [
    cast: fn(:stats_worker, {:report_transaction, [name: "/path", total: 123]}) -> :ok end
  ] do
    ReInspector.Metrics.report_transaction_execution("/path", 123)

    assert called GenServer.cast(:stats_worker, {:report_transaction, [name: "/path", total: 123]})
  end
end

