defmodule ReInspector.App.Workers.MessageBroadcasterWorkerTest do
  use ExUnit.Case, async: false
  use Webtest.Case
  import Mock

  alias ReInspector.App.Workers.MessageBroadcasterWorker

  #handle_cast/2
  test "returns a result expected by OTP" do
    {:noreply, :state} = MessageBroadcasterWorker.handle_cast {:new_request, "id"}, :state
  end

  test_with_mock "executes the broadcast command", BroadcastForTest, [broadcast: fn("id") -> :ok end] do
    Application.put_env(:re_inspector, :broadcast_command, &BroadcastForTest.broadcast/1)

    MessageBroadcasterWorker.handle_cast {:new_request, "id"}, :state

    assert called BroadcastForTest.broadcast("id")
  end

  test "supports no broadcast command" do
    Application.put_env(:re_inspector, :broadcast_command, nil)

    {:noreply, :state} = MessageBroadcasterWorker.handle_cast {:new_request, "id"}, :state
  end

end
