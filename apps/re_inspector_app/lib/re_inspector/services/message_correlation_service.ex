defmodule ReInspector.App.Services.MessageCorrelationService do
  import Lager

  alias ReInspector.Repo
  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.App.Utils.ListUtils
  alias ReInspector.App.Services.ApiRequestService

  import Ecto.Query, only: [from: 2]

  def process_api_request(id, correlators) do
    Lager.info "processing api request #{id}"
    api_request = ApiRequestService.find(id)

    {api_request, correlations, correlator_name} = launch_correlation(api_request, correlators)
    correlation = persist_correlation(correlations)

    ApiRequestService.update(api_request, correlation, correlator_name)
  end

  def launch_correlation(api_request, correlators) do
    Lager.info "launching correlation for api_request #{inspect api_request}"

    correlator = find_correlator(api_request, correlators)
    {
      %ApiRequest{api_request| request_name: correlator.request_name(api_request)},
      correlator.extract_correlation(api_request),
      to_string(correlator)
    }
  end

  def persist_correlation(correlations) do
    update_correlation(correlations, find_previous_correlation(correlations))
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
    |> Enum.filter(fn (value) -> value end)
    |> Enum.map(fn (value) -> find_one_correlation(value) end)
    |> Enum.filter(fn (value) -> value end)
    |> List.first
  end

  defp find_one_correlation(value) do
    from(c in Correlation , where: ^value in c.correlations,  select: c)
    |> Repo.all
    |> List.last
  end
end
