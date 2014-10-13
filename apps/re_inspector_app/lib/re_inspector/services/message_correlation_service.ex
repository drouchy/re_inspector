defmodule ReInspector.App.Services.MessageCorrelationService do
  require Logger

  alias ReInspector.Repo
  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.App.Utils.ListUtils
  alias ReInspector.App.Services.ApiRequestService

  import Ecto.Query, only: [from: 2]

  def process_api_request(id, correlators) do
    Logger.info "processing api request #{id}"
    api_request = ApiRequestService.find(id)

    {api_request, correlations, correlator_name} = launch_correlation(api_request, correlators)
    correlation = persist_correlation(correlations)

    ApiRequestService.update(api_request, correlation, correlator_name)
  end

  def launch_correlation(api_request, correlators) do
    Logger.info "launching correlation for api_request #{inspect api_request}"

    correlator = find_correlator(api_request, correlators)
    enriched = enrich_request(api_request, correlator)

    {
      enriched,
      correlator.extract_correlation(api_request),
      to_string(correlator)
    }
  end

  def persist_correlation(correlations) do
    update_correlation(correlations, find_previous_correlation(correlations))
  end

  defp enrich_request(api_request, correlator) do
    %ApiRequest{api_request|
                request_name:           correlator.request_name(api_request),
                additional_information: correlator.additional_information(api_request)
    }
  end

  defp find_correlator(api_request, correlators) do
    Enum.find correlators, fn (correlator) -> correlator.support? api_request end
  end

  defp update_correlation(correlations, nil) do
    %Correlation{correlations: correlations} |> Repo.insert
  end

  defp update_correlation(correlations, previous_correlation) do
    new_correlations = ListUtils.merge(previous_correlation.correlations, correlations)
    correlation = %{previous_correlation | correlations: new_correlations}
    :ok = Repo.update correlation
    correlation
  end

  defp find_previous_correlation(correlations) do
    correlations
    |> Enum.map(fn (value) -> find_correlations(value) end)
    |> List.flatten
    |> Enum.filter(fn (value) -> ListUtils.merge(correlations, value.correlations) != :unmergeable end)
    |> List.first
  end

  defp find_correlations(nil), do: []
  defp find_correlations(value) do
    from(c in Correlation , where: ^value in c.correlations,  select: c)
    |> Repo.all
  end
end
