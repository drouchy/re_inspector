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

    assert called ErrorProcessorService.process_error(:error, :trace)
  end

  test_with_mock "process the error with a request", ErrorProcessorService, mock do
    ErrorProcessorWorker.handle_cast({:error_raised, :error, :trace, :id}, :state)

    assert called ErrorProcessorService.process_error(:error, :trace, :id)
  end

  defp handle_cast do
    ErrorProcessorWorker.handle_cast({:error_raised, :error, :trace}, :state)
  end

  defp mock, do: [
    process_error: fn(_,_) -> :ok end,
    process_error: fn(_,_,_) -> :ok end
  ]
end