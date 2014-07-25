defmodule ReInspector.Backend.Services.SearchServiceTest do
  use ExUnit.Case
  import Mock

  alias ReInspector.Backend.Services.SearchService

  #search/2
  test_with_mock "delegates the search to the App", ReInspector.App, [search: fn("to_search", _) -> results end] do
    SearchService.search("to_search", options)

    assert called ReInspector.App.search("to_search", options)
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

  defp options, do: %{limit: 20, page: 2}
end