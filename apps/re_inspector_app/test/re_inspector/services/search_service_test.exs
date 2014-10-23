defmodule ReInspector.App.Services.SearchServiceTest do
  use ExUnit.Case

  import ReInspector.Support.Ecto

  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.Repo

  alias ReInspector.App.Services.SearchService

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  #search/2
  test "returns the api requests linked to a correlation that contains the query" do
    insert

    result = SearchService.search("3", %{})

    assert Enum.count(result) == 2
    service_names = Enum.map(result, fn(r) -> r.service_name end)
    assert Enum.member?(service_names, "service 1")
    assert Enum.member?(service_names, "service 3")
  end

  test "limits the search based on the options" do
    big_insert

    result = SearchService.search("3", %{"limit" => 5, "page" => 0})
    assert Enum.count(result) == 5
  end

  test "returns only the first elements" do
    big_insert

    result = SearchService.search("3", %{"limit" => 5, "page" => 2})

    service_names = Enum.map(result, fn(e) -> e.service_name end)
    assert service_names == ["service 10", "service 11", "service 12", "service 13", "service 14"]
  end

  test "by default orders the elements by requested_at ascending" do
    big_insert

    result = SearchService.search("3", %{"limit" => 5, "page" => 0})

    service_names = Enum.map(result, fn(e) -> e.service_name end)
    assert service_names == ["service 0", "service 1", "service 2", "service 3", "service 4"]
  end

  test "can order the elements by requested_at ascending" do
    big_insert

    result = SearchService.search("3", %{"limit" => 5, "page" => 0, "order" => "asc"})

    service_names = Enum.map(result, fn(e) -> e.service_name end)
    assert service_names == ["service 0", "service 1", "service 2", "service 3", "service 4"]
  end

  test "can order the elements by requested_at descending" do
    big_insert

    result = SearchService.search("3", %{"limit" => 5, "page" => 0, "order" => "desc"})

    service_names = Enum.map(result, fn(e) -> e.service_name end)
    assert service_names == ["service 19", "service 18", "service 17", "service 16", "service 15"]
  end

  test "can disable the pagination" do
    big_insert

    result = SearchService.search("3", %{"limit" => "no_limit", "page" => 0})
    assert Enum.count(result) == 20
  end

  #count/2
  test "count the total number of entries despite the limit & page options" do
    big_insert

    result = SearchService.count("3", %{"limit" => 5, "page" => 2})

    assert result == 20
  end

  defp insert do
    correlation_1 = %Correlation{correlations: ["1", "10", "3"]} |> Repo.insert
    correlation_2 = %Correlation{correlations: ["5", "2", "4"]} |> Repo.insert

    %ApiRequest{service_name: "service 1", correlation_id: correlation_1.id} |> Repo.insert
    %ApiRequest{service_name: "service 2", correlation_id: correlation_2.id} |> Repo.insert
    %ApiRequest{service_name: "service 3", correlation_id: correlation_1.id} |> Repo.insert
  end

  defp big_insert do
    correlation = %Correlation{correlations: ["3"]} |> Repo.insert
    Enum.map(0..19, fn (i) ->
      %ApiRequest{
        service_name: "service #{i}",
        correlation_id: correlation.id,
        requested_at: Ecto.DateTime.from_erl {{2014, 7, 12}, {14, i, 12}}
      }
    end)
    |> Enum.reverse
    |> Enum.each(fn(e) -> Repo.insert(e) end)
  end
end
