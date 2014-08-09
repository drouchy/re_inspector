defmodule ReInspector.App.Supervisors.SearchSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      :poolboy.child_spec(:search_worker_pool,  search_pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp search_pool_options do
    Application.get_env(:re_inspector_app, :worker_pools)[:search]
    |> Map.merge(%{name: {:local, :search_worker_pool}, worker_module: ReInspector.App.Workers.SearchWorker})
    |> Map.to_list
  end

end
