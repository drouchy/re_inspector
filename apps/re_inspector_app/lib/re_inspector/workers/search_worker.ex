defmodule ReInspector.App.Workers.SearchWorker do
  use GenServer
  require Logger

  alias ReInspector.App.Services.SearchService

  @doc """
  Starts the config worker.
  """
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def handle_call({:search, query, options}, from, state) do
    results = SearchService.search(query, options)
    {:reply, results, state}
  end

  def handle_call({:count, query, options}, from, state) do
    count = SearchService.count(query, options)
    {:reply, count, state}
  end
end
