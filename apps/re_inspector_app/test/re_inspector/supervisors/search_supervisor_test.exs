defmodule ReInspector.App.Supervisors.SearchSupervisorTest do
  use ExUnit.Case
  use Webtest.Case

  test "it starts the search worker pool" do
    assert Process.whereis(:search_worker_pool) != nil
  end

end
