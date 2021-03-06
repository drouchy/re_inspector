defmodule ReInspector.App.Supervisors.ProcessorsSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      :poolboy.child_spec(:message_correlator_worker_pool,  correlator_pool_options, correlators),
      :poolboy.child_spec(:message_processor_worker_pool,   processor_pool_options,  []),
      worker(ReInspector.App.Workers.ErrorProcessorWorker,     []),
      worker(ReInspector.App.Workers.MessageBroadcasterWorker, []),
      worker(ReInspector.App.Workers.DataCleanerWorker,        [retention])
    ] ++ redis_workers
      ++ rabbitmq_workers
      ++ aws_workers
    supervise(children, strategy: :one_for_one)
  end

  defp correlators, do: Application.get_env(:re_inspector_app, :correlators)

  defp redis_worker(redis_config) do
    worker(ReInspector.App.Workers.RedisMessageListenerWorker, [redis_config[:name], Keyword.delete(redis_config, :name)])
  end

  defp rabbitmq_worker(rabbitmq_config) do
    worker(ReInspector.App.Workers.RabbitMQMessageListenerWorker, [rabbitmq_config[:name], Keyword.delete(rabbitmq_config, :name)])
  end

  defp aws_worker(aws_config) do
    worker(ReInspector.App.Workers.SQSMessageListenerWorker, [aws_config[:name], aws_config])
  end

  defp retention, do: Application.get_env(:re_inspector_app, :retention_in_weeks)

  defp redis_workers do
    Enum.map(config[:redis], fn(redis_config) -> redis_worker(redis_config) end)
  end

  defp rabbitmq_workers do
    Enum.map(config[:rabbitmq], fn(rabbitmq_config) -> rabbitmq_worker(rabbitmq_config) end)
  end

  defp aws_workers do
    Enum.map(config[:aws], fn(aws_config) -> aws_worker(aws_config) end)
  end

  defp config, do: Application.get_env(:re_inspector_app, :listeners, [redis: [], rabbitmq: []])

  defp processor_pool_options do
    Application.get_env(:re_inspector_app, :worker_pools)[:processor]
    |> Dict.merge(%{name: {:local, :message_processor_worker_pool}, worker_module: ReInspector.App.Workers.MessageProcessorWorker})
  end

  defp correlator_pool_options do
    Application.get_env(:re_inspector_app, :worker_pools)[:processor]
    |> Dict.merge(%{name: {:local, :message_correlator_worker_pool}, worker_module: ReInspector.App.Workers.MessageCorrelatorWorker})
  end
end
