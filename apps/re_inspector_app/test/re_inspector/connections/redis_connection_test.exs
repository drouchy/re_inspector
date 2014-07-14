defmodule ReInspector.App.Connections.RedisTest do
  use ExUnit.Case

  import ReInspector.Support.Redis

  setup do
    clear_redis
    on_exit fn ->
      clear_redis
    end
  end

  alias ReInspector.App.Connections.Redis

  # client
  test "it connects to redis and can query" do
    result = Redis.client(opts)
    |> Exredis.query ["SET", "FOO", "BAR"]

    assert result == "OK"
  end

  # length
  test "returns 0 if there is nothing in the list" do
    assert Redis.length(redis_connection, redis_list) == 0
  end

  test "returns the length of the list" do
    query ["RPUSH", redis_list, default_message]
    query ["RPUSH", redis_list, "other #{default_message}"]

    assert Redis.length(redis_connection, redis_list) == 2
  end

  test "returns :invalid if the entry is not a list" do
    query ["DEL", redis_list]
    query ["SET", redis_list, default_message]

    assert Redis.length(redis_connection, redis_list) == :invalid
  end

  # pop
  test "it returns the first element in the list" do
    query ["RPUSH", redis_list, default_message]
    query ["RPUSH", redis_list, "other #{default_message}"]

    assert Redis.pop(redis_connection, redis_list) == default_message
  end

  test "it only removes the first element" do
    query ["RPUSH", redis_list, default_message]
    query ["RPUSH", redis_list, "other #{default_message}"]

    Redis.pop(redis_connection, redis_list)

    assert Redis.length(redis_connection, redis_list) == 1
  end

  test "returns :none if trying to pop and the entry is not a list" do
    query ["DEL", redis_list]
    query ["SET", redis_list, "bar"]

    assert Redis.pop(redis_connection, redis_list) == :none
  end

  test "returns :none if the list does not exist" do
    query ["DEL", redis_list]

    assert Redis.pop(redis_connection, redis_list) == :none
  end

  test "returns :none if the list is empty" do
    query ["RPUSH", redis_list, default_message]
    query ["LPOP", redis_list]

    assert Redis.pop(redis_connection, redis_list) == :none
  end

  # push
  test "it adds the element at the tail of the list" do
    Redis.push(redis_connection, "message 1", failure_list)
    Redis.push(redis_connection, "message 2", failure_list)

    set = query ["LPOP", failure_list]

    assert set == "message 1"
  end

  test "return :ok" do
    :ok = Redis.push(redis_connection, "message 1", failure_list)
  end

  defp default_message, do: "one message in redis"

  defp opts do
    %{host: Application.get_env(:redis, :host), port: Application.get_env(:redis, :port)}
  end
end
