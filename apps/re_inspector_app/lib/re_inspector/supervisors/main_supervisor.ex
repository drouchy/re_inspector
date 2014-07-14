defmodule ReInspector.App.Supervisors.MainSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(ReInspector.App.Workers.ConfigWorker, []),
      worker(ReInspector.App.Workers.MessageListenerWorker, [{redis_client, redis_list}]),
      worker(ReInspector.App.Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end

  defp redis_client, do: ReInspector.App.Connections.Redis.client(redis_options)
  defp redis_list,   do: Application.get_env(:redis, :list)

  defp redis_options, do: Application.get_all_env(:redis)
end
