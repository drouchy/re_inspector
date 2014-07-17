defmodule ReInspector.App.Workers.ErrorProcessorWorkerTest do
  use ExUnit.Case
  import Mock

  alias ReInspector.App.Workers.ErrorProcessorWorker
  alias ReInspector.App.Services.ErrorProcessorService

  #handle_cast/2
  test_with_mock "returns an message conformed to OTP", ErrorProcessorService, mock do
    {:noreply, :state} = handle_cast
  end

  test_with_mock "process the error", ErrorProcessorService, mock do
    handle_cast

    assert called ErrorProcessorService.process_error(:message, :error, :trace)
  end

  defp handle_cast do
    ErrorProcessorWorker.handle_cast({:error_raised, :message, :error, :trace}, :state)
  end

  defp mock, do: [process_error: fn(_,_,_) -> :ok end]
end