defmodule ReInspector.Metrics.Plug.Instrumentation do
  @behaviour Plug
  import Logger

  def init(options), do: options

  def call(conn, opts) do
    start_time = :erlang.now
    Plug.Conn.register_before_send(conn, fn(c) -> monitor_result(c, start_time) end)
  end

  defp monitor_result(conn, start_time) do
    elapsed_time = :timer.now_diff :erlang.now, start_time
    Logger.debug "Instrumented #{path(conn)} - #{div(elapsed_time,1000)}ms"
    ReInspector.Metrics.register_web_transaction(path(conn), elapsed_time)
    conn
  end

  defp path(conn), do: "/#{Enum.join(conn.path_info, "/")}"
end
