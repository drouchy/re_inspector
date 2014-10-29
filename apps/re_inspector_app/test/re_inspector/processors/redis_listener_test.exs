defmodule ReInspector.App.Processors.RedisListenerTest do
  use ExUnit.Case

  alias ReInspector.App.Processors.RedisListener

  import ReInspector.Support.Redis

  @redis_list "redis_list"
  setup do
    clear_redis(@redis_list)
    on_exit fn ->
      clear_redis(@redis_list)
    end
  end

  # listen/2
  test "it reads & parse the message from redis" do
    redis_connection |> Exredis.query ['RPUSH', @redis_list, message]

    message = RedisListener.listen redis_connection, @redis_list

    assert message == %{a: 1}
  end

  test "return :none if nothing is in redis" do
    :none = RedisListener.listen redis_connection, @redis_list
  end

  defp message, do: "{\"a\":1}"
end
