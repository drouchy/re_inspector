defmodule ReInspector.App.Workers.RedisMessageListenerWorkerTest do
  use ExUnit.Case, async: true

  alias ReInspector.App.Workers.RedisMessageListenerWorker
  import ReInspector.Support.Redis

  #init/1
  test "inits correctly" do
    {:ok, _} = RedisMessageListenerWorker.init(redis_options)
  end

  test "inits a process for the redis listener" do
    {_, pid} = RedisMessageListenerWorker.init(redis_options)

    assert Process.alive?(pid)
  end
end
