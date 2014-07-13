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

  defp opts do
    %{host: Application.get_env(:redis, :host), port: Application.get_env(:redis, :port)}
  end
end
