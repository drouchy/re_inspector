defmodule ReInspector.App.Supervisors.ProcessorsSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(ReInspector.App.Workers.MessageCorrelatorWorker, [correlators]),
      worker(ReInspector.App.Workers.ErrorProcessorWorker,    []),
      worker(ReInspector.App.Workers.MessageBroadcasterWorker, []),
      worker(ReInspector.App.Workers.DataCleanerWorker, [retention])
    ] ++ Enum.map(Application.get_env(:listeners, :redis, []), fn(redis_config) -> redis_worker(redis_config) end)
      ++ Enum.map(Application.get_env(:listeners, :rabbitmq, []), fn(rabbitmq_config) -> rabbitmq_worker(rabbitmq_config) end)
    supervise(children, strategy: :one_for_one)
  end

  defp correlators, do: Application.get_env(:re_inspector, :correlators)
  defp redis_config, do: Application.get_env(:listeners, :redis) |> List.first

  defp redis_worker(redis_config) do
    worker(ReInspector.App.Workers.RedisMessageListenerWorker, [redis_config[:name], Map.delete(redis_config, :name)])
  end

  defp rabbitmq_worker(rabbitmq_config) do
    worker(ReInspector.App.Workers.RabbitMQMessageListenerWorker, [rabbitmq_config[:name], Map.delete(rabbitmq_config, :name)])
  end

  defp retention, do: Application.get_env(:re_inspector, :retention_in_weeks)
end
