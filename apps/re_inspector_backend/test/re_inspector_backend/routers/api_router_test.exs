defmodule ReInspector.Backend.ApiRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ReInspector.Backend.Routers.ApiRouter
  alias ReInspector.Backend.Services.SearchService

  # init/1
  test "returns the options" do
    :options = ApiRouter.init :options
  end

  # get version
  test "GET version sends the request" do
    assert version.state == :sent
  end

  test "GET version sets the status to 200" do
    assert version.status == 200
  end

  test "GET version sets the content type" do
    { _header, content_type } = Enum.find(version.resp_headers, fn({name, value}) -> name == "content-type" end)
    assert content_type == "application/json; charset=utf-8"
  end

  test "sets the status of the response" do
    assert version.resp_body == "{\"version\":{\"app\":\"0.0.1\",\"backend\":\"0.0.1\"}}"
  end

  # get search
  test "GET search sends the request" do
    assert search.state == :sent
  end

  test "GET search sets the status to 200" do
    assert search.status == 200
  end

  test "GET search sets the content type" do
    { _header, content_type } = Enum.find(search.resp_headers, fn({name, value}) -> name == "content-type" end)
    assert content_type == "application/json; charset=utf-8"
  end

  test_with_mock "GET search renders the results", SearchService, [search: fn("to_search", _) -> results end] do
    json = ReInspector.App.JsonParser.decode search.resp_body

    assert Enum.count(json[:results]) == 2

    first_result = List.first json[:results]
    assert first_result[:request][:path]    == "/path_1"
    assert first_result[:response][:status] == 200
  end

  test_with_mock "GET search searches with the page & limit options", SearchService, [search: fn("to_search", _) -> results end] do
    ApiRouter.call(conn(:get, "search?q=to_search&page=2&limit=10"), [])

    assert called SearchService.search "to_search", %{"limit" => "10", "page" => "2"}
  end

  test "returns a 404 when the route is not found" do
    response = ApiRouter.call(conn(:get, "/whatever/does/not/matter"), [])

    assert response.status == 404
  end

  defp version, do: ApiRouter.call(conn(:get, "version"), [])
  defp search,  do: ApiRouter.call(conn(:get, "search?q=to_search"), [])

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
end
