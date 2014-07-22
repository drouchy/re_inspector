defmodule ReInspector.App.Supervisors.ProcessorsSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(ReInspector.App.Workers.MessageListenerWorker,   [redis_config[:name], Map.delete(redis_config, :name)]),
      worker(ReInspector.App.Workers.MessageCorrelatorWorker, [correlators]),
      worker(ReInspector.App.Workers.ErrorProcessorWorker,    [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  # defp redis_client, do: ReInspector.App.Connections.Redis.client(redis_options)
  # defp redis_list,   do: Application.get_env(:redis, :list)

  # defp redis_options, do: Application.get_all_env(:redis)
  defp correlators, do: Application.get_env(:re_inspector, :correlators)
  defp redis_config, do: Application.get_env(:listeners, :redis) |> List.first

end
