defmodule ReInspector.Backend.Router do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/auth", to: ReInspector.Backend.Routers.AuthenticationRouter
  forward "/api",  to: ReInspector.Backend.Routers.ApiRouter

  get "/search" do
    conn = fetch_params(conn)

    conn
    |> redirect_to("/api/search?#{URI.encode_query(conn.params)}")
  end

  get "/version" do
    conn
    |> redirect_to("/api/version")
  end

  defp redirect_to(conn, path) do
    conn
    |> put_resp_header("Location", path)
    |> send_resp(302, "")
  end

  match conn do
    conn
    |> send_resp(404, "not found")
  end

end
