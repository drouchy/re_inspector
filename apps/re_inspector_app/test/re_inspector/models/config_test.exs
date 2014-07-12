
defmodule ReInspector.App.ConfigTest do
  use ExUnit.Case

  alias ReInspector.App.Config

  test "it returns the version in the mix file" do
    assert Config.version == "0.0.1"
  end
end
