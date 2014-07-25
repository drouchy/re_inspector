defmodule ReInspector.App.Workers.SearchWorkerTest do
  use ExUnit.Case, async: true
  import Mock

  alias ReInspector.App.Workers.SearchWorker
  alias ReInspector.App.Services.SearchService

  #handle_call/3

  #{:search, query, options}
  test_with_mock "returns the results in an OTP fashion", SearchService, [search: fn(_,_) -> :results end] do
    {:reply, :results, :state} = SearchWorker.handle_call({:search, "query", :options}, self, :state)
  end

  test_with_mock "search the query with the options", SearchService, [search: fn(_,_) -> :results end] do
    SearchWorker.handle_call({:search, "query", :options}, self, :state)

    assert called SearchService.search("query", :options)
  end

  #{:count, query, options}
  test_with_mock "returns the count in an OTP fashion", SearchService, [count: fn(_,_) -> 20 end] do
    {:reply, 20, :state} = SearchWorker.handle_call({:count, "query", :options}, self, :state)
  end

  test_with_mock "count the query with the options", SearchService, [count: fn(_,_) -> 20 end] do
    SearchWorker.handle_call({:count, "query", :options}, self, :state)

    assert called SearchService.count("query", :options)
  end
end
