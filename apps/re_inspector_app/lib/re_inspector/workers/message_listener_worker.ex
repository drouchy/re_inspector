defmodule ReInspector.App.Workers.MessageListenerWorker do
  use GenServer
  import Lager

  @doc """
  Starts the config worker.
  """
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, [name: :re_inspector_message_listener])
  end

  def init({redis_client, redis_list}) do
    Lager.info "starting the message listener #{redis_list}"
    {:ok, spawn_link fn -> listen_redis(redis_client, redis_list) end }
  end

  defp listen_redis(redis_client, redis_list) do
    api_request = ReInspector.App.Processors.RedisListener.listen(redis_client, redis_list)
    |> persist
    |> launch_processing

    :timer.sleep 300
    listen_redis(redis_client, redis_list)
  end

  defp persist(:none), do: :none
  defp persist(:ok),   do: IO.puts "==> ok"; :none
  defp persist(message) do
    message
    |> ReInspector.App.Converters.ApiRequestMessageConverter.to_postgres
    |> ReInspector.App.Services.ApiRequestService.persist
  end

  defp launch_processing(:none), do: :ok
  defp launch_processing(api_request), do: ReInspector.App.process_api_request(api_request.id)
end
