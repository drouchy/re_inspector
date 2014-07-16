defmodule ReInspector.Support.Ecto do
  alias ReInspector.Repo

  import Ecto.Query, only: [from: 2]

  def count_api_requests do
    Enum.count(Repo.all(api_request_query))
  end

  def count_correlations do
    Enum.count(all_correlations)
  end

  def count_uncorrelated_requests do
    from(q in ReInspector.ApiRequest, where: q.correlated_at == nil)
    |> Repo.all
    |> Enum.count
  end

  def first_api_request do
    List.first all_api_requests
  end

  def all_correlations do
    Repo.all(correlation_query)
  end

  def all_api_requests do
    Repo.all api_request_query
  end

  def first_correlation do
    List.first(all_correlations)
  end

  def clean_db do
     Repo.delete_all(ReInspector.ApiRequest)
     Repo.delete_all(ReInspector.Correlation)
  end

  defp api_request_query do
    from q in ReInspector.ApiRequest, []
  end

  defp correlation_query do
    from q in ReInspector.Correlation, []
  end
end
