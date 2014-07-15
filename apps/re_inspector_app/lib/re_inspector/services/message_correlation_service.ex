defmodule ReInspector.App.Services.MessageCorrelationService do
  import Lager

  alias ReInspector.App.Repo
  alias ReInspector.App.ApiRequest
  alias ReInspector.App.Correlation
  alias ReInspector.App.Utils.ListUtils

  import Ecto.Query, only: [from: 2]

  def launch_correlation(correlators, message) do
    Lager.info "launching correlation for message #{inspect message}"

    correlator = find_correlator(correlators, message)
    {
      %ApiRequest{request_name: correlator.request_name(message)},
      correlator.extract_correlation(message)
    }
  end

  def persist_correlation(correlations) do
    update_correlation(correlations, find_previous_correlation(correlations))
  end

  defp find_correlator(correlators, message) do
    Enum.find correlators, fn (correlator) -> correlator.support? message end
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
