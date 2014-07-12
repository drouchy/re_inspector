defmodule ReInspector.Backend.Routers.VersionRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ReInspector.Backend.Routers.VersionRouter

  # init/1
  test "returns the options" do
    :options = VersionRouter.init :options
  end

  # get /version
  test "sends the request" do
    assert connection.state == :sent
  end

  test "sets the status to 200" do
    assert connection.status == 200
  end

  test "sets the content type" do
    { _header, content_type } = Enum.find(connection.resp_headers, fn({name, value}) -> name == "content-type" end)
    assert content_type == "application/json; charset=utf-8"
  end

  test "sets the status of the response" do
    assert connection.resp_body == "{\"version\":{\"app\":\"0.0.1\",\"backend\":\"0.0.1\"}}"
  end

  defp connection, do: VersionRouter.call(conn(:get, "/"), [])
end
