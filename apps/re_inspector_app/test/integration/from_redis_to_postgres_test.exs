defmodule FromRedisToPostgresTest do
  use ExUnit.Case, async: false
  use Webtest.Case
  use Exredis

  import ReInspector.Support.Redis
  import ReInspector.Support.Ecto

  setup do
    clear_redis
    clean_db
    on_exit fn ->
      clear_redis
      clean_db
    end
    :ok
  end

  test "when a request is in redis, it's transformed and persisted into mongodb" do
    { :ok, content } = default_fixture

    redis_connection |> query ["RPUSH", redis_list, content]
    redis_connection |> query ["RPUSH", redis_list, content]

    with_retries 8, 100 do
      assert count_api_requests == 2
    end

    assert first_api_request.service_name == "service 1"
  end

  defp default_fixture, do: File.read fixture_file
  defp fixture_file,    do: Path.expand("../../fixtures/service_1_default_request.json", __ENV__.file())
end
