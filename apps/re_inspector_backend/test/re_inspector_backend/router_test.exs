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

  test "GET /version sets the status to 302" do
    assert version.status == 302
  end

  test "GET /version redirects to the new endpoint" do
    { _header, location } = Enum.find(version.resp_headers, fn({name, value}) -> name == "Location" end)

    assert location == "/api/version"
  end

  # get /search
  test "GET /search sends the request" do
    assert search.state == :sent
  end

  test "GET /search sets the status to 200" do
    assert search.status == 302
  end

  test "GET /search redirects to the new endpoint" do
    { _header, location } = Enum.find(search.resp_headers, fn({name, value}) -> name == "Location" end)

    assert location == "/api/search?limit=10&q=to+search"
  end

  defp version, do: Router.call(conn(:get, "/version"), [])
  defp search,  do: Router.call(conn(:get, "/search?q=to+search&limit=10"), [])
  defp header_value(header_name) do
    { _header, value } = Enum.find(version.resp_headers, fn({name, value}) -> name == "header_name" end)
    value
  end
end
