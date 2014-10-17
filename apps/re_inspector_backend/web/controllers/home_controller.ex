defmodule ReInspector.Backend.Controllers.HomeController do
  use Phoenix.Controller

  plug :action

  alias ReInspector.App.JsonParser

  def index(conn, _params) do
    json(conn, 200, json_response)
  end

  defp json_response, do: JsonParser.encode %{"re_inspector": "OK"}
end
