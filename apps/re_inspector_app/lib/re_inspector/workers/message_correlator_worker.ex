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
    try do
      Lager.info "launching correlation of request #{api_request_id}"
      ReInspector.App.Services.MessageCorrelationService.process_api_request(api_request_id, correlators)
    rescue
      error ->
        IO.puts "--------"
        IO.puts "api_request: #{inspect api_request_id}"
        IO.puts "description: #{inspect error}"
        IO.puts "--------"
        # :gen_server.cast :re_inspector_failure_worker, { :process, message, { error.description, error} }
        { :stop, error.description }
    end
    {:noreply, correlators}
  end

end
