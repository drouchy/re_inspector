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

  # get /not_found
  test "GET /not_found sends the request" do
    assert not_found_request.state == :sent
  end

  test "GET /not_found sets the status to 404" do
    assert not_found_request.status == 404
  end

  test "GET /not_found sets the content type" do
    content_type = Plug.Conn.get_resp_header(not_found_request, "content-type") |> List.first

    assert content_type == "application/json; charset=utf-8"
  end

  # test "sets the status of the response" do
  #   assert home_request.resp_body == "{\"re_inspector\":\"OK\"}"
  # end

  defp home_request, do: simulate_request(:get, "/")
  defp not_found_request, do: simulate_request(:get, "/not_found")
end
