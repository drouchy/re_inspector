defmodule ReInspector.App.Workers.MessageCorrelatorWorker do
  use GenServer
  import Lager

  @doc """
  Starts the config worker.
  """
  def start_link(correlators) do
    GenServer.start_link(__MODULE__, correlators, [name: :re_inspector_message_correlator])
  end

  def handle_cast({:process, api_request_id}, correlators) do
    Lager.info "launching correlation of request #{api_request_id}"
    ReInspector.App.Services.MessageCorrelationService.process_api_request(api_request_id, correlators)
    {:noreply, correlators}
  end

end
