defmodule PlugHelper do

  defmacro __using__(_opts) do
    quote do
      use Plug.Test
      def simulate_request(http_method, path) do
        conn = conn(http_method, path) |> put_req_header("accept", "application/json; charset=utf-8")
        ReInspector.Backend.Router.call(conn, [])
      end

      def simulate_html_request(http_method, path) do
        conn = conn(http_method, path) |> put_req_header("accept", "text/html; charset=utf-8")
        ReInspector.Backend.Router.call(conn, [])
      end
    end
  end
end