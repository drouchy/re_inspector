defmodule ReInspector.App.Workers.DataCleanerWorker do
  use GenServer
  require Logger

  alias ReInspector.App.Services.CleaningService

  def start_link(retention) do
    GenServer.start_link(__MODULE__, retention, [name: :re_inspector_data_cleaner])
  end

  def init(retention) do
    {:ok, retention}
  end

  def handle_cast(:clean_old_data, retention) do
    CleaningService.clean_old_api_requests(Chronos.weeks_ago(retention))

    {:noreply, retention}
  end
end
