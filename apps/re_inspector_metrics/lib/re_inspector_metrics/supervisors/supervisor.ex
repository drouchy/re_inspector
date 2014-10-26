defmodule ReInspector.Metrics.Supervisors.Supervisor do
  use Supervisor

  def start_link do
    :statman_server.add_subscriber(:statman_aggregator)
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(ReInspector.Metrics.Supervisors.NewRelicSupervisor, []),
      worker(ReInspector.Metrics.Workers.StatsWorker, []),
      worker(:statman_aggregator, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end