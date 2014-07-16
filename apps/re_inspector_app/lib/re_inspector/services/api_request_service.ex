defmodule ReInspector.App.Services.ApiRequestService do
  import Lager

  alias ReInspector.ApiRequest
  alias ReInspector.Repo

  def persist(attributes) do
    Lager.debug "persist api_request with: #{inspect(attributes)}"
    struct(ApiRequest, attributes) |> Repo.insert
  end
end
