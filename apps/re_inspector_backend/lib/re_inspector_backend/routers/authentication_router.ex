defmodule ReInspector.Backend.Routers.AuthenticationRouter do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch
  plug :fetch

  alias ReInspector.Backend.Services.AuthenticationService

  def init(options) do
    options
  end

  get ":provider/call_back" do
    conn = fetch_params(conn)
    user = AuthenticationService.authenticate(provider, conn.params)

    conn
    |> call_back_for(user)
  end

  match conn do
    conn
    |> send_resp(404, "not found")
  end

  defp fetch(conn, _opts), do: fetch_params(conn)

  defp call_back_for(conn, nil), do: send_resp(conn, 403, "")
  defp call_back_for(conn, user) do
    location = URI.encode_query %{authentication_token: user.access_token, login: user.login}

    conn
    |> put_resp_header("Location", "/?#{location}")
    |> send_resp(302, "")
  end

end