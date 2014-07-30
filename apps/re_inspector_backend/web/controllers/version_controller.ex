defmodule ReInspector.Backend.Controllers.VersionController do
  use ReInspector.Backend.Controllers.AuthenticatedController

  alias ReInspector.App.JsonParser

  def show(conn, _params) do
    json(conn, 200, json_response)
  end

  defp json_response, do: JsonParser.encode version

  defp version do
    %{
      "version" => %{
        "app" => "0.0.1",
        "backend" => "0.0.1"
      }
    }
  end
end
