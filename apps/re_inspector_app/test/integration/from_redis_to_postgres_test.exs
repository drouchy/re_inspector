defmodule FromRedisToPostgresTest do
  use ExUnit.Case, async: false
  use Webtest.Case
  use Exredis
  import Mock

  import ReInspector.Support.Redis
  import ReInspector.Support.Ecto
  import ReInspector.Support.Fixtures

  setup do
    clear_redis
    clean_db
    on_exit fn ->
      clear_redis
      clean_db
    end
    :ok
  end

  test "when a request is in redis, it's transformed and persisted into postgres" do
    redis_connection |> query ["RPUSH", redis_list, default_fixture]
    redis_connection |> query ["RPUSH", redis_list, default_fixture]

    with_retries 8, 100 do
      assert count_api_requests == 2
    end

    assert first_api_request.service_name == "service 1"
  end

  test "end-to-end correlation test - from redis to postgres and correlated" do
    redis_connection |> query ["RPUSH", redis_list, default_fixture]
    redis_connection |> query ["RPUSH", redis_list, default_fixture]

    with_retries 20, 100 do
      assert count_api_requests == 2
      assert count_uncorrelated_requests == 0
    end

    [first_api_request|tail] = all_api_requests
    assert first_api_request.service_name == "service 1"
    assert first_api_request.correlator_name == "Elixir.ReInspector.Test.Service1Correlator"
  end

  test "end-to-end correlation test - executes the broadcast command" do
    Application.put_env(:re_inspector, :broadcast_command, fn(id) -> redis_connection |> query ["SET", "BROADCAST", "1"] end)
    redis_connection |> query ["SET", "BROADCAST", "0"]
    redis_connection |> query ["RPUSH", redis_list, default_fixture]

    with_retries 20, 100 do
      assert query(redis_connection, ["GET", "BROADCAST"]) != "0"
    end

    assert query(redis_connection, ["GET", "BROADCAST"]) == "1"
  end
end
