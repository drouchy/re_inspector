defmodule ReInspector.App.Services.SearchService do
  import Logger

  import Ecto.Query

  alias ReInspector.Correlation
  alias ReInspector.Repo

  def search(query, options) do
    Logger.info "search '#{query}' with options: #{inspect options}"
    ecto_query(query)
    |> select([c, q], {c,q})
    |> order_by([_c, q], q.requested_at)
    |> limit_results(options)
    |> Repo.all
    |> Enum.map fn({correlation, api_request}) -> %{api_request | correlation: correlation} end
  end

  def count(query, _options) do
    Logger.debug "counting total result for '#{query}'"
    ecto_query(query)
    |> select([_c, q], count(q.id))
    |> Repo.one
  end

  defp ecto_query(term) do
    from(c in Correlation,
      where: ^term in c.correlations,
      left_join: q in c.requests
    )
  end

  defp limit_results(query, %{"limit" => "no_limit"}), do: query
  defp limit_results(query, %{"limit" => limit, "page" => page}) do
    query
    |> limit(limit)
    |> offset(limit*page)
  end
  defp limit_results(query, _), do: query
end
