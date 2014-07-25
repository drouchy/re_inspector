defmodule ReInspector.Backend.Routers.ApiRouter do
  import Plug.Conn
  use Plug.Router

  alias ReInspector.App.JsonParser
  alias ReInspector.Backend.Renderers.ApiRequestRenderer
  alias ReInspector.Backend.Services.SearchService

  alias ReInspector.Backend.Plugs

  plug Plugs.AuthenticationPlug, enabled: Application.get_env(:authentication, :enabled)
  plug :match
  plug :dispatch
  plug :fetch

  def init(options) do
    options
  end

  get "version" do
    json = JsonParser.encode version

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end

  get "search" do
    conn = fetch_params(conn)
    options = Map.drop(conn.params, ["q"])

    results = SearchService.search(conn.params["q"], options)
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
end
