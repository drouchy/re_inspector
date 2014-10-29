defmodule ReInspector.App.Workers.MessageProcessorWorker do
  use GenServer
  require Logger
  import ReInspector.Metrics.Instrumentation

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def handle_cast({:process, message}, state) do
    instrument {:background, "message_processor" } , process(message)
    {:noreply, state}
  end

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

  defp launch_processing(api_request), do: ReInspector.App.process_api_request(api_request.id)
end
