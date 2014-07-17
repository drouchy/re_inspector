defmodule ReInspector.App.Workers.ErrorProcessorWorker do
  use GenServer
  import Lager

  alias ReInspector.App.Services.ErrorProcessorService

  def handle_cast({:error_raised, error, stack_trace}, state) do
    Lager.error("An error has been raised: #{error.description}")
    ErrorProcessorService.process_error(error, stack_trace)
    {:noreply, state}
  end
end