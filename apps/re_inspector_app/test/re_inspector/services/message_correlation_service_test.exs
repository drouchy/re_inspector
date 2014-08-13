defmodule ReInspector.App.Services.MessageCorrelationServiceTest do
  use ExUnit.Case
  import ReInspector.Support.Fixtures
  import ReInspector.Support.Ecto
  import Ecto.Query, only: [from: 2]

  alias ReInspector.ApiRequest
  alias ReInspector.Repo

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  alias ReInspector.App.Services.MessageCorrelationService

  #process_api_request/2
  test "launches the correlation process & stores the result" do
    struct(ApiRequest, default_message)
    |> Ecto.Model.put_primary_key(15)
    |> Repo.insert

    processed = MessageCorrelationService.process_api_request(15, correlators)

    processed = load_api_request processed.id
    assert processed.correlation.get.id != nil
    assert processed.correlator_name == "Elixir.ReInspector.Test.Service1Correlator"
    assert Enum.member?(processed.correlation.get.correlations, "24C43")
  end

  #launch_correlation/2
  test "enriches the message with the request name" do
    {enriched, _, _} = MessageCorrelationService.launch_correlation(struct(ApiRequest, default_message), correlators)

    assert enriched.request_name == "service 1 request"
  end

  test "keeps the previous properties of the api request" do
    {enriched, _, _} = MessageCorrelationService.launch_correlation(struct(ApiRequest, default_message), correlators)

    assert enriched.path == "/article/123/comments"
  end

  test "returns the correlations of the message" do
    {_, correlations, _} = MessageCorrelationService.launch_correlation(struct(ApiRequest, default_message), correlators)

    assert correlations == ["123", "24C43", nil]
  end

  test "returns the correlator name" do
    {_, _, correlator_name} = MessageCorrelationService.launch_correlation(struct(ApiRequest, default_message), correlators)

    assert correlator_name == "Elixir.ReInspector.Test.Service1Correlator"
  end

  test "works whaever the order of the correlators" do
    {enriched, correlations, _} = MessageCorrelationService.launch_correlation(struct(ApiRequest, default_message), Enum.reverse(correlators))

    assert correlations == ["123", "24C43", nil]
    assert enriched.request_name == "service 1 request"
  end

  #persist_correlation/1
  test "inserts a new correlation when nothing can be found in db" do
    MessageCorrelationService.persist_correlation ["123", "24C43", nil]

    assert count_correlations == 1
    assert first_correlation.correlations == ["123", "24C43", nil]
  end

  test "returns a new correlation when nothing can be found in db" do
    correlation = MessageCorrelationService.persist_correlation ["123", "24C43", nil]

    assert correlation.id != nil
  end

  test "updates a previous correlation when it shares some values" do
    correlation = %ReInspector.Correlation{correlations: [nil, "24C43", "1234"]}
    |> ReInspector.Repo.insert

    inserted = MessageCorrelationService.persist_correlation ["123", "24C43", nil]

    assert correlation.id == inserted.id
  end

  test "returns a new correlation when a previous correlation has been found but not at the same index" do
    %ReInspector.Correlation{correlations: [nil, "24C43", "1234"]}
    |> ReInspector.Repo.insert

    correlation = MessageCorrelationService.persist_correlation ["24C43", nil, nil]

    assert count_correlations == 2
  end

  test "returns a new correlation when a previous correlation has been found but can't be merged because of an additional entry" do
    %ReInspector.Correlation{correlations: ["123", "24C43", nil]}
    |> ReInspector.Repo.insert

    correlation = MessageCorrelationService.persist_correlation ["456", "24C43", nil]

    assert count_correlations == 2
  end

  defp correlators, do: [ReInspector.Test.Service1Correlator, ReInspector.Test.Service2Correlator]
end
