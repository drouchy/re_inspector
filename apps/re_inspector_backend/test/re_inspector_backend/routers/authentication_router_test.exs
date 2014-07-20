defmodule ReInspector.Backend.AuthenticationRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ReInspector.Backend.Routers.AuthenticationRouter
  alias ReInspector.Backend.Services.AuthenticationService
  alias ReInspector.User

  # init/1
  test "returns the options" do
    :options = AuthenticationRouter.init :options
  end

  # get version
  test_with_mock "GET version sends the request", AuthenticationService, mock_authentication do
    assert execute_callback.state == :sent
  end

  test_with_mock "GET github/call_back returns a 302 status", AuthenticationService, mock_authentication do
    assert execute_callback.status == 302
  end

  test_with_mock "GET github/call_back returns location header", AuthenticationService, mock_authentication do
    location = Plug.Conn.get_resp_header(execute_callback, "Location") |> List.first

    assert location == "/?authentication_token=abcdef&login=user+name"
  end

  test_with_mock "GET github/call_back returns a 403 with an invalid authentication", AuthenticationService,
  [ authenticate: fn(_,_) -> nil end ] do
    assert execute_callback.status == 403
  end

  defp execute_callback, do: AuthenticationRouter.call(conn(:get, "github/call_back?code=1234&state=456"), [])
  defp mock_authentication do
    [
      authenticate: fn("github", %{"code" => "1234", "state" => "456"}) -> user end
    ]
  end
  defp user, do: %User{access_token: "abcdef", login: "user name"}
end
