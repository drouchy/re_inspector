defmodule ReInspector.App.Supervisors.MainSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(ReInspector.App.Supervisors.ProcessorsSupervisor, []),
      supervisor(ReInspector.App.Supervisors.SearchSupervisor, []),

      worker(ReInspector.App.Workers.ConfigWorker, []),
      worker(ReInspector.Repo, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
