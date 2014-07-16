defmodule ReInspector.App.Services.ApiRequestServiceTest do
  use ExUnit.Case
  use Chronos, date: {2014, 7, 16}

  import ReInspector.Support.Ecto

  alias ReInspector.App.Services.ApiRequestService
  alias ReInspector.Repo

  alias ReInspector.ApiRequest
  alias ReInspector.Correlation

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  #persist/1
  test "it creates an api request with the attributes" do
    request = ApiRequestService.persist(attributes)

    assert request.method == "POST"
  end

  test "it assigns an id" do
    request = ApiRequestService.persist(attributes)

    assert request.id != nil
  end

  test "it persist in the db" do
    ApiRequestService.persist(attributes)

    assert count_api_requests == 1
    assert first_api_request.method == "POST"
  end

  #find/1
  test "returns nil if not found" do
    assert ApiRequestService.find(10) == nil
  end

  test "returns the entry when found" do
    Ecto.Model.put_primary_key(%ApiRequest{}, 10) |> Repo.insert

    found = ApiRequestService.find(10)

    assert found != nil
    assert found.id == 10
  end

  #update/3
  test "links the api request & the correlation" do
    {correlation, api_request, correlator_name} = build_update_fixture

    updated = ApiRequestService.update api_request, correlation, correlator_name

    assert updated.correlation.id == correlation.id
  end

  test "sets the correlator name" do
    {correlation, api_request, correlator_name} = build_update_fixture

    updated = ApiRequestService.update api_request, correlation, correlator_name

    assert updated.correlator_name == "one correlator"
  end

  test "sets the correlated date" do
    {correlation, api_request, correlator_name} = build_update_fixture

    updated = ApiRequestService.update api_request, correlation, correlator_name

    assert updated.correlated_at != nil
    {2014, 7, 16} = {updated.correlated_at.year, updated.correlated_at.month, updated.correlated_at.day}
  end

  defp attributes, do: %{method: "POST", path: "/url/1"}
  defp build_update_fixture do
    {
      %Correlation{correlations: ["1", "2"]} |> Repo.insert,
      %ApiRequest{} |> Repo.insert,
      "one correlator"
    }
  end
end
