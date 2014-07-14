defmodule ReInspector.App.Supervisors.ProcessorsSupervisorTest do
  use ExUnit.Case
  use Webtest.Case

  test "it starts the message listener worker" do
    assert Process.whereis(:re_inspector_message_listener) != nil
  end

  test "it restarts the message listener worker when it crashes" do
    pid = Process.whereis(:re_inspector_message_listener)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_message_listener)
      assert new_pid != nil
      assert new_pid != pid
    end
  end

  test "it starts the message processor worker" do
    assert Process.whereis(:re_inspector_message_correlator) != nil
  end

  test "it restarts the message processor worker when it crashes" do
    pid = Process.whereis(:re_inspector_message_correlator)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_message_correlator)
      assert new_pid != nil
      assert new_pid != pid
    end
  end
end
