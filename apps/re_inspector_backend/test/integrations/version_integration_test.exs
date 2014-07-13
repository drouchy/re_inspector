defmodule ReInspector.Backend.Integration.VersionTest do
  use ExUnit.Case, async: true

  test "requests the version of the app" do
    body = fetch('/version')

    assert Regex.run(~r/"version"/, body) != nil
  end

  def fetch(path) do
    response = HTTPoison.get "http://localhost:4000#{path}"
    response.body
  end
end
