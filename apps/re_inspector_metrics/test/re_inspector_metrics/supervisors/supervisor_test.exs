defmodule ReInspector.Metrics.Supervisors.SupervisorTest do
  use ExUnit.Case
  use Webtest.Case

  test "it starts the redis message listener worker" do
    assert Process.whereis(:statman_aggregator) != nil
  end

  test "it restarts the redis message listener worker when it crashes" do
    pid = Process.whereis(:statman_aggregator)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:statman_aggregator)
      assert new_pid != nil
      assert new_pid != pid
    end
  end
end