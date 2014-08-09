defmodule ReInspector.App.Workers.RedisMessageListenerWorker do
  use GenServer
  import Lager

  @doc """
  """
  def start_link(name, args) do
    worker_name = "re_inspector_redis_message_listener_#{name}"
    GenServer.start_link(__MODULE__, args, [name: String.to_atom(worker_name)])
  end

  def init(redis_options) do
    Lager.info "starting the message listener #{redis_options[:list]}"
    try do
      redis_client = ReInspector.App.Connections.Redis.client(redis_options)
      pid = spawn_link fn -> listen_redis(redis_client, redis_options[:list]) end
    {:ok, pid }
    rescue
      e -> IO.inspect e
      raise e
    end
  end

  defp listen_redis(redis_client, redis_list) do
    ReInspector.App.Processors.RedisListener.listen(redis_client, redis_list)
    |> process

    :timer.sleep 300
    listen_redis(redis_client, redis_list)
  end

  defp process(:none), do: :none
  defp process(message) do
    try do
      message
      |> ReInspector.App.Converters.ApiRequestMessageConverter.to_postgres
      |> ReInspector.App.Services.ApiRequestService.persist
      |> launch_processing
    rescue
      error ->
        ReInspector.App.process_error(error, :erlang.get_stacktrace())
        raise error
    end
  end

  defp launch_processing(:none), do: :ok
  defp launch_processing(api_request), do: ReInspector.App.process_api_request(api_request.id)
end
