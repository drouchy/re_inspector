defmodule ReInspector.Backend.Controllers.HomeController do
  use Phoenix.Controller

  plug :action

  alias ReInspector.App.JsonParser

  def index(conn, _params) do
    json(conn, 200, json_response)
  end

  def not_found(conn, _params) do
    IO.puts "-----> not found"
    render conn, "not_found"
  end

  # def error(conn, _params) do
  #   render conn, "error"
  # end

  defp json_response, do: JsonParser.encode %{"re_inspector": "OK"}
end
