defmodule ReInspector.Backend.Integration.SearchTest do
  use ExUnit.Case, async: false

  import ReInspector.Backend.Fixtures
  import ReInspector.Support.Ecto

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  test "requests the version of the app" do
    ReInspector.Backend.Fixtures.insert_fixtures

    body = fetch('/search?q=3')

    assert Regex.run(~r/"service 1"/, body) != nil
    assert Regex.run(~r/"service 3"/, body) != nil
  end

  def fetch(path) do
    response = HTTPoison.get "http://localhost:4000#{path}"
    response.body
  end
end
