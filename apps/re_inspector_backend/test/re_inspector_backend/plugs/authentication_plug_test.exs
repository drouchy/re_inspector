defmodule ReInspector.Backend.Plugs.AuthenticationPlugTest do
  use ExUnit.Case
  use Plug.Test
  import Mock

  import ReInspector.Backend.Fixtures
  import ReInspector.Support.Ecto

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  alias ReInspector.Backend.Plugs.AuthenticationPlug
  alias ReInspector.Backend.Authentication.Github

  #init/1
  test "returns the args" do
    assert AuthenticationPlug.init([foo: :bar]) == [foo: :bar]
  end

  #call/2
  test "returns 401 if there is no authorization header" do
    conn = call_with_no_token
    assert conn.status == 401
  end

  test "returns 401 if authorization header is incorrect" do
    conn = call_with_token "1234567890"
    assert conn.status == 401
  end

  test "returns 401 if there is no user with the access token header" do
    insert_user(login: "user", access_token: "0987654321")

    conn = call_with_token "token 1234567890"
    assert conn.status == 401
  end

  test "does not touch the conn if there is an user with the access token header" do
    insert_user(login: "user", access_token: "1234567890")

    conn = call_with_token "token 1234567890"
    assert conn.status == nil
  end

  test "support the header Authorization capitalized" do
    insert_user(login: "user", access_token: "1234567890")

    conn = call_with_headers %{"Authorization" => "token 1234567890"}
    assert conn.status == nil
  end

  defp call(conn) do
    conn |> AuthenticationPlug.call([enabled: true])
  end

  defp call_with_no_token,        do: call_with_headers %{}
  defp call_with_token(token),    do: call_with_headers %{"authorization" => token}
  defp call_with_headers(headers) do
    call %{conn(:get, "/") | req_headers: headers}
  end
end