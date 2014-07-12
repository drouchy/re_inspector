defmodule ReInspector.Integration.GenServer do
  use ExUnit.Case, async: true

  test "it starts the config server" do
    version = GenServer.call(:re_inspector_config, :version)

    assert version != nil
  end

end
