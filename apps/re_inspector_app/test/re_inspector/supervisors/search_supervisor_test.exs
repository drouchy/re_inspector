defmodule ReInspector.App.Supervisors.SearchSupervisorTest do
  use ExUnit.Case
  use Webtest.Case

  test "it starts the search worker" do
    assert Process.whereis(:re_inspector_search) != nil
  end

  test "it restarts the search worker when it crashes" do
    pid = Process.whereis(:re_inspector_search)

    Process.exit pid, :to_test

    with_retries 5, 10 do
      new_pid = Process.whereis(:re_inspector_search)
      assert new_pid != nil
      assert new_pid != pid
    end
  end
end
