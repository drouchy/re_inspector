defmodule ReInspector.App.Services.CleaningService do
  import Lager

  import Ecto.Query, only: [from: 2]

  alias ReInspector.ApiRequest
  alias ReInspector.ProcessingError
  alias ReInspector.Correlation
  alias ReInspector.Repo

  def clean_old_api_requests(cut_off) do
    Lager.info "Cleaning old Api Requests requested before #{inspect cut_off}"

    limit = Ecto.DateTime.from_erl({cut_off, {0, 0, 0}})

    to_remove = from(q in ApiRequest, where: q.requested_at < ^limit, select: q) |> Repo.all

    correlation_ids = Enum.map(to_remove, fn(q) -> q.correlation_id end) |> Enum.uniq

    Enum.each to_remove,       fn(q) ->  clean_api_request(q)  end
    Enum.each correlation_ids, fn(id) -> clean_correlation(id) end
  end

  defp clean_api_request(q) do
    error = from(e in ProcessingError, where: e.api_request_id == ^q.id, select: e) |> Repo.one
    case error do
      nil -> :none
      _   -> Repo.delete(error)
    end

    Repo.delete(q)
  end

  defp clean_correlation(nil), do: :done
  defp clean_correlation(id) do
    nb_correlated = from(q in ApiRequest, where: q.correlation_id == ^id, select: count(q.id)) |> Repo.one
    case nb_correlated do
      0 -> Repo.get(Correlation, id) |> Repo.delete
      _ -> :done
    end
  end
end
