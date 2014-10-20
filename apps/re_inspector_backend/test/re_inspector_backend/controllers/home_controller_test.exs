defmodule ReInspector.Backend.HomeControllerTest do
  use ExUnit.Case
  use PlugHelper

  # get /

  ## JSON requests
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

  test "GET / render the json" do
    assert home_request.resp_body == "{\"re_inspector\":\"OK\"}"
  end

  ##json
  test "html GET / sends the request" do
    assert html_home_request.state == :sent
  end

  test "html GET / sets the status to 200" do
    assert html_home_request.status == 200
  end

  test "html GET / sets the content type" do
    content_type = Plug.Conn.get_resp_header(html_home_request, "content-type") |> List.first

    assert content_type == "text/html; charset=utf-8"
  end

  test "html GET / renders the view" do
    assert Regex.match?(~r/here later the app/, html_home_request.resp_body)
  end

  # get /not_found

  ## JSON requests
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

  test "GET /not_found does not render any body" do
    assert not_found_request.resp_body == ""
  end

  ## Html requests
  test "html GET /not_found sends the request" do
    assert html_not_found_request.state == :sent
  end

  test "html GET /not_found sets the status to 404" do
    assert html_not_found_request.status == 404
  end

  test "html GET /not_found sets the content type" do
    content_type = Plug.Conn.get_resp_header(html_not_found_request, "content-type") |> List.first

    assert content_type == "text/html; charset=utf-8"
  end

  test "html GET /not_found rendere the view" do
    assert Regex.match?(~r/does not exist/, html_not_found_request.resp_body)
  end

  defp home_request, do: simulate_request(:get, "/")
  defp html_home_request, do: simulate_html_request(:get, "/")
  defp not_found_request, do: simulate_request(:get, "/not_found")
  defp html_not_found_request, do: simulate_html_request(:get, "/not_found")
end
