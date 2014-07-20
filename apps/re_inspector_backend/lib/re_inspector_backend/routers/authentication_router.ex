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
    |> send_resp(200, user.access_token)
  end

  match conn do
    conn
    |> send_resp(404, "not found")
  end

  defp fetch(conn, _opts), do: fetch_params(conn)

end