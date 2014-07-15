defmodule ReInspector.App.Services.MessageCorrelationServiceTest do
  use ExUnit.Case
  import ReInspector.Support.Fixtures

  alias ReInspector.App.Services.MessageCorrelationService

  #launch_correlation/2
  test "enrich the message with the request name" do
    {enriched, _} = MessageCorrelationService.launch_correlation(correlators, default_message)

    assert enriched.request_name == "service 1 request"
  end

  test "returns the correlations of the message" do
    {_, correlations} = MessageCorrelationService.launch_correlation(correlators, default_message)

    assert correlations == ["123", "24C43", nil]
  end

  test "works whaever the order of the correlators" do
    {enriched, correlations} = MessageCorrelationService.launch_correlation(Enum.reverse(correlators), default_message)

    assert correlations == ["123", "24C43", nil]
    assert enriched.request_name == "service 1 request"
  end

  defp correlators, do: [ReInspector.Test.Service1Correlator, ReInspector.Test.Service2Correlator]
end
