defmodule ReInspector.Backend.Controllers.ApiRequestController do
  use Phoenix.Controller
  plug ReInspector.Metrics.Plug.Instrumentation, []

  alias ReInspector.App.Services.ApiRequestService
  alias ReInspector.App.JsonParser
  alias ReInspector.Backend.Renderers.ApiRequestRenderer

  plug :action

  def show(conn, params) do
    api_request = ApiRequestService.find String.to_integer(params["id"])

    case api_request do
      nil     -> json(conn, 404, "{}")
      request -> json(conn, 200, json(request))
    end
  end

  def json(api_request) do
    %{
      "api_request" => ApiRequestRenderer.render(api_request)
    }
    |> JsonParser.encode
  end
end
