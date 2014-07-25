defmodule ReInspector.Backend.Services.SearchServiceTest do
  use ExUnit.Case
  import Mock

  alias ReInspector.Backend.Services.SearchService

  #search/2
  test_with_mock "delegates the search to the App", ReInspector.App, mock_search do
    SearchService.search("to_search", options)

    assert called ReInspector.App.search("to_search", options)
  end

  test_with_mock "returns a pagination", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", options)

    assert pagination != nil
  end

  test_with_mock "the pagination contains the total number of results", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", options)

    assert pagination["total"] == 250
  end

  test_with_mock "the pagination contains the path for the current page", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", options)

    assert pagination["current_page"] == "/api/search?limit=20&page=2&q=to_search"
  end

  test_with_mock "the pagination contains the path for the next page", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", options)

    assert pagination["next_page"] == "/api/search?limit=20&page=3&q=to_search"
  end

  test_with_mock "the pagination contains the path for the previous page", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", options)

    assert pagination["previous_page"] == "/api/search?limit=20&page=1&q=to_search"
  end

  test_with_mock "the pagination does not contain the path for the previous page when already on the first one", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", %{"limit" => 20, "page" => 0, "path" => "/api/search"})

    assert pagination["previous_page"] == nil
  end

  test_with_mock "the pagination does not contain the path for the next page when already on th last one", ReInspector.App, mock_search do
    {_, pagination} = SearchService.search("to_search", %{"limit" => 20, "page" => 12, "path" => "/api/search"})

    assert pagination["next_page"] == nil
  end

  defp mock_search do
    [
      search: fn("to_search", _) -> results end,
      count:  fn("to_search", _) -> 250 end
    ]
  end

  defp results do
    [
      %ReInspector.ApiRequest{
        path: "/path_1",
        status: 200
      },
      %ReInspector.ApiRequest{
        path: "/path_2",
        status: 404
      }
    ]
  end

  defp options, do: %{"limit" => 20, "page" => 2, "path" => "/api/search"}
end