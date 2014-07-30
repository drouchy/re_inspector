defmodule ReInspector.Backend.BroadcastingServiceTest do
  use ExUnit.Case
  import Mock

  alias ReInspector.Backend.BroadcastingService

  test "return :ok" do
    {:ok, "id"} = BroadcastingService.new_request("id")
  end

  test_with_mock "publishes a broadcast event on the WS channel", Phoenix.Channel, [broadcast: fn(_,_,_,_) -> :ok end] do
    BroadcastingService.new_request("id")

    assert called Phoenix.Channel.broadcast("re_inspector", "api_request", "new:request", %{api_request_id: "id"})
  end
end