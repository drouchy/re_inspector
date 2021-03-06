defmodule FromPostgrestoCorrelationTest do
  use ExUnit.Case, async: false
  use Webtest.Case
  use Exredis

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

  test "when 2 related request are inserted in redis, they are correlated" do
    all_fixtures
    |> Enum.map(fn (message) -> struct(ReInspector.ApiRequest, message) |> ReInspector.Repo.insert end)
    |> Enum.map(fn (message) -> message.id end)
    |> Enum.each(fn (id) -> ReInspector.App.process_api_request(id) end)

    with_retries 10, 100 do
      assert count_uncorrelated_requests == 0
    end

    correlation = all_correlations |> List.first
    Enum.map all_api_requests, fn(api_request) ->
      assert api_request.correlation_id == correlation.id
    end
  end
end
