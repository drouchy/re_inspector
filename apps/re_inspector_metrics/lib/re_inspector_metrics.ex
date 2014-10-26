defmodule ReInspector.Metrics do
  use Application

  import Logger

  def start(), do: start(nil, nil)
  def start(_type, _args) do
    ReInspector.Metrics.Supervisors.Supervisor.start_link
  end

  def register_web_transaction(path, total) do
    Logger.debug "register web transaction: #{path} - #{total/1000}ms"
  end

  def instrument_web_transaction(path, function) do
    Logger.debug "instrument web transaction #{path}"
  end
end
