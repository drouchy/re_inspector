defmodule ReInspector.Backend.AuthenticationControllerTest do
  use ExUnit.Case, async: false
  use PlugHelper

  import Mock

  alias ReInspector.Backend.Routers.AuthenticationRouter
  alias ReInspector.Backend.Services.AuthenticationService
  alias ReInspector.Backend.Authentication.Github
  alias ReInspector.User

  # get :provider/authentication
  test_with_mock "GET /auth/github/authenticate sends the request", AuthenticationService, mock_authentication do
    assert execute_authenticate.state == :sent
  end

  test_with_mock "GET /auth/github/authenticate returns a 302 status", AuthenticationService, mock_authentication do
    assert execute_authenticate.status == 302
  end

  test_with_mock "redirect to github authentication", Github, [authorization_url: fn(_) -> "github url" end] do
    location = Plug.Conn.get_resp_header(execute_authenticate, "Location") |> List.first

    assert location == "github url"
  end

  test_with_mock "reads the github settings from the config", Github, [authorization_url: fn(_) -> "github url" end] do
    location = Plug.Conn.get_resp_header(execute_authenticate, "Location") |> List.first

    assert called Github.authorization_url([client_id: "GITHUB_CLIENT_ID", client_secret: "GITHUB_CLIENT_SECRET"])
  end

  # get :provider/call_back
  test_with_mock "GET version sends the request", AuthenticationService, mock_authentication do
    assert execute_callback.state == :sent
  end

  test_with_mock "GET /auth/github/call_back returns a 302 status", AuthenticationService, mock_authentication do
    assert execute_callback.status == 302
  end

  test_with_mock "GET /auth/github/call_back returns location header", AuthenticationService, mock_authentication do
    location = Plug.Conn.get_resp_header(execute_callback, "Location") |> List.first

    assert location == "/?authentication_token=abcdef&login=user+name"
  end

  test_with_mock "GET /auth/github/call_back returns a 403 with an invalid authentication", AuthenticationService,
  [ authenticate: fn(_,_) -> nil end ] do
    assert execute_callback.status == 403
  end

  defp execute_callback,     do: simulate_request(:get, "/auth/github/call_back?code=1234&state=456")
  defp execute_authenticate, do: simulate_request(:get, "/auth/github/authenticate")

  defp mock_authentication do
    [
      authenticate: fn("github", %{"code" => "1234", "state" => "456"}) -> user end
    ]
  end
  defp user, do: %User{access_token: "abcdef", login: "user name"}
end
