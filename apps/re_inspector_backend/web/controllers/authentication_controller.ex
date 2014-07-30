defmodule ReInspector.Backend.Controllers.AuthenticationController do
  use Phoenix.Controller

  alias ReInspector.Backend.Services.AuthenticationService
  alias ReInspector.Backend.Authentication.Github

  def authenticate(conn, params) do
    conn
    |> put_resp_header("Location", Github.authorization_url(Application.get_all_env(:github)))
    |> text(302, "")
  end

  def call_back(conn, params) do
    user = AuthenticationService.authenticate(conn.params["provider"], conn.params)

    conn
    |> call_back_for(user)
  end

  defp fetch(conn, _opts), do: fetch_params(conn)

  defp call_back_for(conn, nil), do: text(conn, 403, "")
  defp call_back_for(conn, user) do
    location = URI.encode_query %{authentication_token: user.access_token, login: user.login}

    conn
    |> put_resp_header("Location", "/?#{location}")
    |> text(302, "")
  end
end