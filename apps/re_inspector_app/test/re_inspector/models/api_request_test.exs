defmodule ReInspector.ApiRequestTest do
  use ExUnit.Case

  alias ReInspector.ApiRequest

  # correlations/1
  test "returns the correlations from the correlation" do
    request = %ApiRequest{correlation: correlation}

    assert ApiRequest.correlations(request) == [nil, "cor 1", "cor 2", nil]
  end

  test "returns an empty list if there is no correlation" do
    request = %ApiRequest{correlation: nil}

    assert ApiRequest.correlations(request) == []
  end

  defp correlation, do: %ReInspector.Correlation{correlations: [nil, "cor 1", "cor 2", nil]}
end
