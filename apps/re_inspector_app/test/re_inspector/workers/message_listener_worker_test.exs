defmodule ReInspector.App.Workers.MessageListenerWorkerTest do
  use ExUnit.Case, async: true
  import Mock

  alias ReInspector.App.Workers.MessageListenerWorker
  import ReInspector.Support.Redis

  #init/1
  test "inits correctly" do
    {:ok, _} = MessageListenerWorker.init({redis_connection, redis_list})
  end

  test "inits a process for the redis listener" do
    {_, pid} = MessageListenerWorker.init({redis_connection, redis_list})

    assert Process.alive?(pid)
  end
end
