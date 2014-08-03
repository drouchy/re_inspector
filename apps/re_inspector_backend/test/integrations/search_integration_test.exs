defmodule ReInspector.Backend.Integration.SearchTest do
  use IntegrationTest.Case

  test "requests the version of the app" do
    ReInspector.Backend.Fixtures.insert_fixtures

    body = fetch('/api/search?q=3')

    assert Regex.run(~r/"service 1"/, body) != nil
    assert Regex.run(~r/"service 3"/, body) != nil
  end
end
