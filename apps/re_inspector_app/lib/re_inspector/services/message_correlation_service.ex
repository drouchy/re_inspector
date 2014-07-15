defmodule ReInspector.App.Services.MessageCorrelationService do
  import Lager

  alias ReInspector.App.ApiRequest

  def launch_correlation(correlators, message) do
    Lager.info "launching correlation for message #{inspect message}"

    correlator = find_correlator(correlators, message)
    {
      %ApiRequest{request_name: correlator.request_name(message)},
      correlator.extract_correlation(message)
    }
  end

  defp find_correlator(correlators, message) do
    Enum.find correlators, fn (correlator) -> correlator.support? message end
  end
end
