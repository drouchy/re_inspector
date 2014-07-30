defmodule ReInspector.Backend.Controllers.SearchController do
  use ReInspector.Backend.Controllers.AuthenticatedController

  alias ReInspector.App.JsonParser
  alias ReInspector.Backend.Services.SearchService
  alias ReInspector.Backend.Renderers.ApiRequestRenderer

  plug :fetch

  def index(conn, _params) do
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

  defp fetch(conn, _opts), do: fetch_params(conn)

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
