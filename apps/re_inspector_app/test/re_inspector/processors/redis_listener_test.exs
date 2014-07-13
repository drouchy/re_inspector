defmodule ReInspector.App.Processors.RedisListenerTest do
  use ExUnit.Case

  alias ReInspector.App.Processors.RedisListener

  import ReInspector.Support.Redis

  setup do
    clear_redis
    on_exit fn ->
      clear_redis
    end
  end

  test "it reads & parse the message from redis" do
    redis_connection |> Exredis.query ['RPUSH', redis_list, message]

    message = RedisListener.listen redis_connection, redis_list

    assert message == %{a: 1}
  end

  defp message, do: "{\"a\":1}"
end
