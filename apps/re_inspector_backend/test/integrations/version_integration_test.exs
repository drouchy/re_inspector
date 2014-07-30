defmodule ReInspector.Backend.Integration.VersionTest do
  use ExUnit.Case, async: true

  test "requests the version of the app" do
    body = fetch('/api/version')

    assert Regex.run(~r/"version"/, body) != nil
  end

  def fetch(path) do
    response = HTTPoison.get "http://localhost:#{port}#{path}"
    response.body
  end

  defp port do
    Application.get_env(:phoenix, ReInspector.Backend.Router)[:port]
  end
end
