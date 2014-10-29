defmodule ReInspector.Metrics do
  use Application

  import Logger

  def start(), do: start(nil, nil)
  def start(_type, _args) do
    ReInspector.Metrics.Supervisors.Supervisor.start_link
  end

  def report_transaction_execution(name, total) do
    Logger.debug "report transaction execution: #{name} - #{total/1000}ms"
    GenServer.cast(:stats_worker, {:report_transaction, [name: name, total: total]})
  end

end
