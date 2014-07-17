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
    List.first Repo.all api_request_query
  end

  def all_correlations do
    Repo.all(correlation_query)
  end

  def all_api_requests do
    Repo.all from q in ReInspector.ApiRequest, preload: :correlation
  end

  def first_correlation do
    List.first(all_correlations)
  end

  def first_processing_error do
    List.first Repo.all(error_query)
  end

  def first_processing_error_with_api_request do
    List.first Repo.all(full_error_query)
  end

  def clean_db do
     Repo.delete_all(ReInspector.ProcessingError)
     Repo.delete_all(ReInspector.ApiRequest)
     Repo.delete_all(ReInspector.Correlation)
  end

  defp api_request_query do
    from q in ReInspector.ApiRequest, []
  end

  defp correlation_query do
    from q in ReInspector.Correlation, []
  end

  defp error_query do
    from e in ReInspector.ProcessingError, []
  end

  defp full_error_query do
    from e in ReInspector.ProcessingError, preload: :api_request
  end
end
