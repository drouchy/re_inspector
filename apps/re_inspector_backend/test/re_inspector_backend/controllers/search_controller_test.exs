defmodule ReInspector.Backend.Controllers.SearchControllerTest do
  use ExUnit.Case, async: true
  use PlugHelper

  import Mock

  alias ReInspector.Backend.Services.SearchService

  # get /api/search
  test "GET /api/search sends the request" do
    assert search_request.state == :sent
  end

  test "GET /api/search sets the status to 200" do
    assert search_request.status == 200
  end

  test "GET /api/search sets the content type" do
    content_type = Plug.Conn.get_resp_header(search_request, "content-type") |> List.first

    assert content_type == "application/json; charset=utf-8"
  end

  test_with_mock "GET /api/search renders the results", SearchService, [search: fn("to_search", _) -> results end] do
    json = ReInspector.App.JsonParser.decode search_request.resp_body

    assert Enum.count(json[:results]) == 2

    first_result = List.first json[:results]
    assert first_result[:request][:path]    == "/path_1"
    assert first_result[:response][:status] == 200
  end

  test_with_mock "GET /api/search searches renders the pagination", SearchService, [search: fn("to_search", _) -> results end] do
    json = ReInspector.App.JsonParser.decode search_request.resp_body

    assert json[:pagination] != nil
    assert json[:pagination][:total] == 250

  end

  test_with_mock "GET /api/search searches with the page & limit options", SearchService, [search: fn("to_search", _) -> results end] do
    simulate_request(:get, "/api/search?q=to_search&page=2&limit=10")

    assert called SearchService.search "to_search", %{"limit" => 10, "page" => 2, "path" => "/api/search"}
  end

  test_with_mock "GET /api/search searches assigns default options", SearchService, [search: fn("to_search", _) -> results end] do
    simulate_request(:get, "/api/search?q=to_search")

    assert called SearchService.search "to_search", %{"limit" => 30, "page" => 0, "path" => "/api/search"}
  end

  defp search_request,  do: simulate_request(:get, "/api/search?q=to_search")

  defp results do
    {
      [
        %ReInspector.ApiRequest{
          path: "/path_1",
          status: 200
        },
        %ReInspector.ApiRequest{
          path: "/path_2",
          status: 404
        }
      ],
      %{
        "total" => 250
      }
    }
  end
end
