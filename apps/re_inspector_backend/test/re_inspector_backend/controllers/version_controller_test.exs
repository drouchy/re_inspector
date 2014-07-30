defmodule ReInspector.Backend.VersionControllerTest do
  use ExUnit.Case
  use PlugHelper

  # get /version
  test "GET /version sends the request" do
    assert version_request.state == :sent
  end

  test "GET /version sets the status to 200" do
    assert version_request.status == 200
  end

  test "GET /version sets the content type" do
    content_type = Plug.Conn.get_resp_header(version_request, "content-type") |> List.first

    assert content_type == "application/json; charset=utf-8"
  end

  test "sets the status of the response" do
    assert version_request.resp_body == "{\"version\":{\"app\":\"0.0.1\",\"backend\":\"0.0.1\"}}"
  end

  defp version_request, do: simulate_request(:get, "/api/version")
end
