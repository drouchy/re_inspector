defmodule ReInspector.Metrics.Plug.Instrumentation do
  @behaviour Plug
  import Logger

  def init(options), do: options

  def call(conn, opts) do
    start_time = :erlang.now
    request_path = path(conn)
    ReInspector.Metrics.TransactionRegistry.current_transaction request_path
    Plug.Conn.register_before_send(conn, fn(c) -> monitor_result(c, start_time) end)
  end

  defp monitor_result(conn, start_time) do
    elapsed_time = :timer.now_diff :erlang.now, start_time
    request_path = path(conn)
    Logger.debug fn -> "Instrumented #{request_path} - #{div(elapsed_time,1000)}ms" end
    ReInspector.Metrics.report_transaction_execution(request_path, elapsed_time)
    conn
  end

  defp path(conn), do: "/#{Enum.join(conn.path_info, "/")}"
end
