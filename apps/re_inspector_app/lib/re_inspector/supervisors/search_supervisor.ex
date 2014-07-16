defmodule ReInspector.App.Supervisors.SearchSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(ReInspector.App.Workers.SearchWorker, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
