defmodule ReInspector.Support.Ecto do
  alias ReInspector.App.Repo

  import Ecto.Query, only: [from: 2]

  def count_api_requests do
    Enum.count(Repo.all(api_request_query))
  end

  def first_api_request do
    List.first(Repo.all(api_request_query))
  end

  def clean_db do
     Repo.delete_all(ReInspector.App.ApiRequest)
  end

  defp api_request_query do
    from q in ReInspector.App.ApiRequest, []
  end
end
