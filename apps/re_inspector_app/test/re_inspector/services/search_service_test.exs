defmodule ReInspector.App.Services.SearchServiceTest do
  use ExUnit.Case

  import ReInspector.Support.Ecto
  import Ecto.Query, only: [from: 2]

  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.Repo

  alias ReInspector.App.Services.SearchService

  setup do
    clean_db
    insert
    #on_exit fn -> clean_db end
    :ok
  end

  test "returns the api requests linked to a correlation that contains the query" do
    result = SearchService.search("3", %{})

    assert Enum.count(result) == 2
    assert List.first(result).service_name == "service 1"
    assert List.last(result).service_name == "service 3"
  end

  defp insert do
    correlation_1 = %Correlation{correlations: ["1", "10", "3"]} |> Repo.insert
    correlation_2 = %Correlation{correlations: ["5", "2", "4"]} |> Repo.insert

    %ApiRequest{service_name: "service 1", correlation_id: correlation_1.id} |> Repo.insert
    %ApiRequest{service_name: "service 2", correlation_id: correlation_2.id} |> Repo.insert
    %ApiRequest{service_name: "service 3", correlation_id: correlation_1.id} |> Repo.insert
  end

end
