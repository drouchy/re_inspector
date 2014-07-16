defmodule ReInspector.App.Services.MessageCorrelationServiceTest do
  use ExUnit.Case
  import ReInspector.Support.Fixtures
  import ReInspector.Support.Ecto

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  alias ReInspector.App.Services.MessageCorrelationService

  #launch_correlation/2
  test "enrich the message with the request name" do
    {enriched, _, _} = MessageCorrelationService.launch_correlation(correlators, default_message)

    assert enriched.request_name == "service 1 request"
  end

  test "returns the correlations of the message" do
    {_, correlations, _} = MessageCorrelationService.launch_correlation(correlators, default_message)

    assert correlations == ["123", "24C43", nil]
  end

  test "returns the correlator name" do
    {_, _, correlator_name} = MessageCorrelationService.launch_correlation(correlators, default_message)

    assert correlator_name == "Elixir.ReInspector.Test.Service1Correlator"
  end

  test "works whaever the order of the correlators" do
    {enriched, correlations, _} = MessageCorrelationService.launch_correlation(Enum.reverse(correlators), default_message)

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

  defp correlators, do: [ReInspector.Test.Service1Correlator, ReInspector.Test.Service2Correlator]
end
