defmodule ReInspector.App.Workers.DataCleanerWorkerTest do
  use ExUnit.Case
  import Mock

  alias ReInspector.App.Workers.DataCleanerWorker
  alias ReInspector.App.Services.CleaningService

  #init/1
  test "returns the OTP result for initialisation" do
    {:ok, 10} = DataCleanerWorker.init(10)
  end

  #handle_cast/2
  test "returns an OTP compliant result" do
    {:noreply, 6} = DataCleanerWorker.handle_cast(:clean_old_data, 6)
  end

  test_with_mock "asks the service the clean the old data", CleaningService, [clean_old_api_requests: fn(_) -> :ok end] do
    with_mock Chronos, [weeks_ago: fn(6) -> {2014, 06, 23} end] do
      DataCleanerWorker.handle_cast(:clean_old_data, 6)

      assert called CleaningService.clean_old_api_requests({2014, 06, 23})
    end
  end
end
