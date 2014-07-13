defmodule ReInspector.App.Services.ApiRequestService do
  import Lager

  alias ReInspector.App.ApiRequest
  alias ReInspector.App.Repo

  def persist(attributes) do
    Lager.debug "persist api_request with: #{inspect(attributes)}"
    struct(ApiRequest, attributes) |> Repo.insert
  end
end
