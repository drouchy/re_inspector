defmodule ReInspector.App.Workers.MessageCorrelatorWorker do
  use GenServer
  require Logger

  @doc """
  Starts the config worker.
  """
  def start_link(correlators) do
    GenServer.start_link(__MODULE__, correlators)
  end

  def handle_cast({:process, api_request_id}, correlators) do
    try do
      Logger.info "launching correlation of request #{api_request_id}"
      ReInspector.App.Services.MessageCorrelationService.process_api_request(api_request_id, correlators)
      GenServer.cast :re_inspector_message_broadcaster, {:new_request, api_request_id}
    rescue
      error -> ReInspector.App.process_error(error, :erlang.get_stacktrace(), api_request_id)
      { :stop, error }
    end
    {:noreply, correlators}
  end

end
