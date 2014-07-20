defmodule ReInspector.Backend.Plugs.AuthenticationPlug do
  @behaviour Plug
  import Plug.Conn

  alias ReInspector.Backend.Authentication.Github
  alias ReInspector.App.Services.UserService

  def init(options) do
    options
  end

  def call(conn, [enabled: false]), do: conn
  def call(conn, [enabled: true])   do
    authenticated = authenticated?(conn)
    authenticated_call(authenticated, conn, [])
  end

  defp authenticated_call(false, conn, []), do: send_resp(conn, 401, unauthenticated_body)
  defp authenticated_call(true, conn, []),  do: conn

  defp config, do: Application.get_all_env(:github)
  defp unauthenticated_body do
    %{authentication_url: Github.authorization_url(config)}
    |> ReInspector.App.JsonParser.encode
  end

  defp authenticated?(conn) do
    user = Plug.Conn.get_req_header(conn, "authorization")
    |> List.first
    |> extract_token
    |> UserService.find_by_token

    user != nil
  end

  defp extract_token(nil), do: "none"
  defp extract_token(header_value) do
    captures = Regex.named_captures(~r/^token (?<token>.*)$/, header_value)
    captures["token"]
  end
end