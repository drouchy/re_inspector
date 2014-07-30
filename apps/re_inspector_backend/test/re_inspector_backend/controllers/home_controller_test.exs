defmodule ReInspector.Backend.HomeControllerTest do
  use ExUnit.Case
  use PlugHelper

  # get /
  test "GET / sends the request" do
    assert home_request.state == :sent
  end

  test "GET / sets the status to 200" do
    assert home_request.status == 200
  end

  test "GET / sets the content type" do
    content_type = Plug.Conn.get_resp_header(home_request, "content-type") |> List.first

    assert content_type == "application/json; charset=utf-8"
  end

  test "sets the status of the response" do
    assert home_request.resp_body == "{\"re_inspector\":\"OK\"}"
  end

  defp home_request, do: simulate_request(:get, "/")
end
