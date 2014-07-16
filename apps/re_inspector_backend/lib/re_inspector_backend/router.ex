defmodule ReInspector.Backend.Router do
  import Plug.Conn
  use Plug.Router

  alias ReInspector.App.JsonParser
  alias ReInspector.Backend.Renderers.ApiRequestRenderer

  plug :match
  plug :dispatch
  plug :fetch
  # plug Plug.Parsers, parsers: [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART]

  get "/version" do
    json = JsonParser.encode version

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end

  get "/search" do
    conn = fetch_params(conn)
    results = ReInspector.App.search(conn.params["q"], %{})
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

  match _ do
    raise NotFound
  end

end
