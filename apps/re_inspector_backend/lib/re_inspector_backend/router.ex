defmodule ReInspector.Backend.Router do
  import Plug.Conn
  use Plug.Router

  alias ReInspector.App.JsonParser
  alias ReInspector.Backend.Renderers.ApiRequestRenderer

  plug :match
  plug :dispatch
  plug :fetch
  # plug Plug.Parsers, parsers: [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART]

  get "/search" do
    conn = fetch_params(conn)

    conn
    |> redirect_to("/api/search?#{URI.encode_query(conn.params)}")
  end

  get "/version" do
    conn
    |> redirect_to("/api/version")
  end

  get "/api/version" do
    json = JsonParser.encode version

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end

  get "/api/search" do
    conn = fetch_params(conn)
    options = Map.drop(conn.params, ["q"])

    results = ReInspector.App.search(conn.params["q"], options)
    rendered = Enum.map(results, fn(api_request) -> ApiRequestRenderer.render(api_request) end)
    json = JsonParser.encode %{results: rendered}

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end

  defp version do
    %{
      "version" => %{
        "app" => "0.0.1",
        "backend" => "0.0.1"
      }
    }
  end

  defp fetch(conn, _opts), do: fetch_params(conn)

  match conn do
    conn
    |> send_resp(404, "not found")
  end

  defp redirect_to(conn, path) do
    conn
    |> put_resp_header("Location", path)
    |> send_resp(302, "")
  end
end
