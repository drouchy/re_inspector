defmodule ReInspector.Backend.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ReInspector.Backend.Router

  # init/1
  test "returns the options" do
    :options = Router.init :options
  end

  # get /version
  test "GET /version sends the request" do
    assert version.state == :sent
  end

  test "GET /version sets the status to 200" do
    assert version.status == 200
  end

  test "GET /version sets the content type" do
    { _header, content_type } = Enum.find(version.resp_headers, fn({name, value}) -> name == "content-type" end)
    assert content_type == "application/json; charset=utf-8"
  end

  test "sets the status of the response" do
    assert version.resp_body == "{\"version\":{\"app\":\"0.0.1\",\"backend\":\"0.0.1\"}}"
  end

  # get /search
  test "GET /search sends the request" do
    assert search.state == :sent
  end

  test "GET /search sets the status to 200" do
    assert search.status == 200
  end

  test "GET /search sets the content type" do
    { _header, content_type } = Enum.find(search.resp_headers, fn({name, value}) -> name == "content-type" end)
    assert content_type == "application/json; charset=utf-8"
  end

  test_with_mock "GET /search renders the results", ReInspector.App, [search: fn("to_search", _) -> results end] do
    json = ReInspector.App.JsonParser.decode search.resp_body

    assert Enum.count(json[:results]) == 2

    first_result = List.first json[:results]
    assert first_result[:request][:path]    == "/path_1"
    assert first_result[:response][:status] == 200
  end

  defp version, do: Router.call(conn(:get, "/version"), [])
  defp search,  do: Router.call(conn(:get, "/search?q=to_search"), [])

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
