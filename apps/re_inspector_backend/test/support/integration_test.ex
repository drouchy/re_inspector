defmodule IntegrationTest.Case do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case, async: false

      import ReInspector.Backend.Fixtures
      import ReInspector.Support.Ecto

      setup do
        clean_db
        on_exit fn -> clean_db end
        :ok
      end

      def fetch(path) do
        { :ok, response } = HTTPoison.get "http://localhost:#{port}#{path}"
        response.body
      end

      defp port do
        Application.get_env(:phoenix, ReInspector.Backend.Router)[:http][:port]
      end
    end
  end
end