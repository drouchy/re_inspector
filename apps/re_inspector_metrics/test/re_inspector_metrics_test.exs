defmodule ReInspector.MetricsTest do
  use ExUnit.Case
  import Mock

  #register_web_transaction/2
  test_with_mock "cast a message for processing", GenServer,
  [
    cast: fn(:stats_worker, {:web_transaction, [path: "/path", total: 123]}) -> :ok end
  ] do
    ReInspector.Metrics.register_web_transaction("/path", 123)

    assert called GenServer.cast(:stats_worker, {:web_transaction, [path: "/path", total: 123]})
  end
end

