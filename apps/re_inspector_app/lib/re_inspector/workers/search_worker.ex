defmodule ReInspector.App.Workers.SearchWorker do
  use GenServer
  import Lager

  alias ReInspector.App.Services.SearchService

  @doc """
  Starts the config worker.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :re_inspector_search])
  end

  def handle_call({:search, query, options}, from, state) do
    results = SearchService.search(query, options)
    {:reply, results, state}
  end
end
