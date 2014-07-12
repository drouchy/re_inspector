defmodule ReInspector.AppTest do
  use ExUnit.Case

  test "returns the config version" do
    version = ReInspector.App.version

    assert version == ReInspector.App.Mixfile.project[:version]
  end
end
