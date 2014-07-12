defmodule ReInspector.Backend.Integration.VersionTest do
  use ExUnit.Case, async: true

  test "requests the version of the app" do
    body = fetch('/version')

    assert Regex.run(~r/"version"/, body) != nil
  end

  def fetch(url) do
    { :ok, {{_version, 200, _reason_phrase}, _headers, body } } = :httpc.request('http://localhost:4000/' ++ url )
    to_string body
  end
end
