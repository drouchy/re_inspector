defmodule ReInspector.Backend.Routers.AuthenticationRouter do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch
  plug :fetch

  def init(options) do
    options
  end

  get "github/call_back" do
    conn
    |> send_resp(200, "")
  end

  match conn do
    conn
    |> send_resp(404, "not found")
  end

  defp fetch(conn, _opts), do: fetch_params(conn)

end