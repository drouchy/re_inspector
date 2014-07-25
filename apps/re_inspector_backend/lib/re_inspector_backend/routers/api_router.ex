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

    default_options = %{"limit" => 30, "page" => 0, "path" => "/api/search"}
    params_options = parse_conn_params(conn.params)
    options = Map.merge(params_options, default_options, &merge_confict/3)

    {results, pagination} = SearchService.search(conn.params["q"], options)

    rendered = Enum.map(results, fn(api_request) -> ApiRequestRenderer.render(api_request) end)
    json = JsonParser.encode %{results: rendered, pagination: pagination}

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

  defp parse_conn_params(params) do
    %{
      "limit" => param_to_int(params["limit"]),
      "page"  => param_to_int(params["page"])
    }
  end

  defp param_to_int(value) when is_bitstring(value) do
    String.to_integer value
  end
  defp param_to_int(nil), do: nil

  defp merge_confict(_key, nil, default_val), do: default_val
  defp merge_confict(_key, params_val, _default_val), do: params_val
end
