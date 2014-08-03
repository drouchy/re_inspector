defmodule ReInspector.Backend.Integration.VersionTest do
  use IntegrationTest.Case

  test "requests the version of the app" do
    body = fetch('/api/version')

    assert Regex.run(~r/"version"/, body) != nil
  end

end
