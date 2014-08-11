defmodule ReInspector.App.Workers.ErrorProcessorWorker do
  use GenServer
  import Logger

  alias ReInspector.App.Services.ErrorProcessorService

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :re_inspector_error_processor])
  end

  def handle_cast({:error_raised, error, stack_trace}, state) do
    Logger.error("An error has been raised: '#{inspect error}'")
    ErrorProcessorService.process_error(error, stack_trace)
    {:noreply, state}
  end

  def handle_cast({:error_raised, error, stack_trace, request_id}, state) do
    Logger.error("An error has been raised: '#{inspect error}' for request #{request_id}")
    ErrorProcessorService.process_error(error, stack_trace, request_id)
    {:noreply, state}
  end
end