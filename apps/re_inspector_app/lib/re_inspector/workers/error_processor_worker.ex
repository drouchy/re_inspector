defmodule ReInspector.App.Workers.ErrorProcessorWorker do
  use GenServer
  import Lager

  alias ReInspector.App.Services.ErrorProcessorService

  def handle_cast({:error_raised, message, error, stack_trace}, state) do
    Lager.error("An error has been raised: #{message}")
    IO.inspect "#{message} - #{error} - #{stack_trace}"
    ErrorProcessorService.process_error(message, error, stack_trace)
    {:noreply, state}
  end
end