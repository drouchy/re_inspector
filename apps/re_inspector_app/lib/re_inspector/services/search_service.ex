defmodule ReInspector.App.Services.SearchService do
  import Lager

  import Ecto.Query, only: [from: 2]

  alias ReInspector.Correlation
  alias ReInspector.Repo

  def search(query, options) do
    Lager.info "search '#{query}' with options: #{inspect options}"
    ecto_query(query)
    |> Repo.all
    |> Enum.map(fn(correlation) -> correlation.requests.all end)
    |> List.flatten
  end

  defp ecto_query(term) do
    from c in Correlation, where: ^term in c.correlations, preload: :requests
  end
end
