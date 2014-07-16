defmodule ReInspector.AppTest do
  use ExUnit.Case
  import Mock

  #version/0
  test "returns the config version" do
    version = ReInspector.App.version

    assert version == ReInspector.App.Mixfile.project[:version]
  end

  #process_api_request/1
  test_with_mock "cast a message for processing", GenServer, [cast: fn(:re_inspector_message_correlator, {:process, 10}) -> :ok end] do
    ReInspector.App.process_api_request(10)

    assert called GenServer.cast(:re_inspector_message_correlator, {:process, 10})
  end
end
