defmodule ReInspector.Backend.Controllers.HomeController do
  use Phoenix.Controller

  plug ReInspector.Metrics.Plug.Instrumentation, []
  plug :action

  alias ReInspector.App.JsonParser

  def index(conn, _params) do
    case request_content_type(conn) do
      "application/json" -> json conn, 200, json_response
      "text/html"        -> render conn, "index"
    end
  end

  def not_found(conn, _params) do
    case request_content_type(conn) do
      "application/json" -> json conn, 404, ''
      "text/html"        -> render conn, "not_found"
    end
  end

  # def error(conn, _params) do
  #   render conn, "error"
  # end

  defp json_response, do: JsonParser.encode %{"re_inspector": "OK"}

  defp request_content_type(conn) do
    Plug.Conn.get_req_header(conn, "accept")
    |> List.first
    |> String.split(";")
    |> List.first
    |> String.split(",")
    |> List.first
    |> String.strip
  end
end
