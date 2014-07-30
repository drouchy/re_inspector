defmodule PlugHelper do

  defmacro __using__(_opts) do
    quote do
      use Plug.Test
      def simulate_request(http_method, path) do
        conn = conn(http_method, path) |> put_req_header("accept", "application/json")
        ReInspector.Backend.Router.call(conn, [])
      end
    end
  end
end