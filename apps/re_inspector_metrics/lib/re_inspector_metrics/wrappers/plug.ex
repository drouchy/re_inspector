defmodule ReInspector.Metrics.Plug.Instrumentation do
  @behaviour Plug
  import Logger

  def init(options), do: options

  def call(conn, opts) do
    path = "/#{Enum.join(conn.path_info, "/")}"
    Logger.debug "Instrumentation plug for #{path}"
    conn
  end
end
