defmodule ReInspector.App.Supervisors.ProcessorsSupervisorTest do
  use ExUnit.Case
  use Webtest.Case

  test "it starts the redis message listener worker" do
    assert Process.whereis(:re_inspector_redis_message_listener_test) != nil
  end

  test "it restarts the redis message listener worker when it crashes" do
    pid = Process.whereis(:re_inspector_redis_message_listener_test)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_redis_message_listener_test)
      assert new_pid != nil
      assert new_pid != pid
    end
  end

  test "it starts the rabbitmq message listener worker" do
    assert Process.whereis(:re_inspector_rabbitmq_message_listener_local) != nil
  end

  test "it restarts the rabbitmq message listener worker when it crashes" do
    pid = Process.whereis(:re_inspector_rabbitmq_message_listener_local)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_rabbitmq_message_listener_local)
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

  test "it starts the error processor worker" do
    assert Process.whereis(:re_inspector_error_processor) != nil
  end

  test "it restarts the error processor worker when it crashes" do
    pid = Process.whereis(:re_inspector_error_processor)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_error_processor)
      assert new_pid != nil
      assert new_pid != pid
    end
  end

  test "it starts the message broadcaster worker" do
    assert Process.whereis(:re_inspector_message_broadcaster) != nil
  end

  test "it restarts the message broadcaster worker when it crashes" do
    pid = Process.whereis(:re_inspector_message_broadcaster)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_message_broadcaster)
      assert new_pid != nil
      assert new_pid != pid
    end
  end

  test "it starts the data cleaner worker" do
    assert Process.whereis(:re_inspector_data_cleaner) != nil
  end

  test "it restarts the data cleaner worker when it crashes" do
    pid = Process.whereis(:re_inspector_data_cleaner)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_data_cleaner)
      assert new_pid != nil
      assert new_pid != pid
    end
  end
end
