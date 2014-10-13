defmodule ReInspector.App.Workers.MessageCorrelatorWorkerTest do
  use ExUnit.Case, async: true
  import Mock

  alias ReInspector.App.Workers.MessageCorrelatorWorker

  test_with_mock "launch the processing of the api request", ReInspector.App.Services.MessageCorrelationService, [process_api_request: fn(10, _correlators) -> :done end] do
    MessageCorrelatorWorker.handle_cast({:process, 10}, correlators)

    assert called ReInspector.App.Services.MessageCorrelationService.process_api_request(10, correlators)
  end

  test_with_mock "returns the :noreply expected by OTP", ReInspector.App.Services.MessageCorrelationService, [process_api_request: fn(10, _correlators) -> :done end] do
    {:noreply, correlators} = MessageCorrelatorWorker.handle_cast({:process, 10}, correlators)
  end

  defp correlators, do: [:correlator_1, :correlator_2]
end
