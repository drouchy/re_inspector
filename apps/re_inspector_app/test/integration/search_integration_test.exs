defmodule ReInspector.Integration.SearchCorrelationTest do
  use ExUnit.Case, async: false

  import ReInspector.Support.Redis
  import ReInspector.Support.Ecto

  alias ReInspector.Correlation
  alias ReInspector.ApiRequest
  alias ReInspector.Repo

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  test "can search around correlated requests" do
    insert_fixtures

    result = ReInspector.App.search("2")

    assert Enum.count(result) == 7
    assert Enum.all?(result, fn(q) -> q.request_name == "test" || q.request_name == "test2" end)
  end

  test "can count the number of correlated requests" do
    insert_fixtures

    result = ReInspector.App.count("2")

    assert result == 7
  end

  defp insert_fixtures do
    correlation_1 = %Correlation{correlations: ["1", "2", nil]} |> Repo.insert
    correlation_2 = %Correlation{correlations: ["2", "4", nil]} |> Repo.insert
    correlation_3 = %Correlation{correlations: ["7", nil, "9"]} |> Repo.insert

    Enum.each(1..3, fn(i) ->
      %ApiRequest{request_name: "test", correlation_id: correlation_1.id} |> Repo.insert
    end)

    Enum.each(1..5, fn(i) ->
      %ApiRequest{request_name: "test3", correlation_id: correlation_3.id} |> Repo.insert
    end)

    Enum.each(1..4, fn(i) ->
      %ApiRequest{request_name: "test2", correlation_id: correlation_2.id} |> Repo.insert
    end)
  end
end