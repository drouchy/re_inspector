defmodule ReInspector.App.Services.ApiRequestService do
  import Lager
  import Ecto.Query, only: [from: 2]

  alias ReInspector.ApiRequest
  alias ReInspector.Repo

  def persist(attributes) do
    Lager.debug "persist api_request with: #{inspect(attributes)}"
    struct(ApiRequest, attributes) |> Repo.insert
  end

  def find(id) do
    Lager.debug "find api_request with id #{id}"
    from(q in ApiRequest, where: q.id == ^id, select: q)
    |> Repo.all
    |> List.first
  end

  def update(api_request, correlation, correlator_name) do
    Lager.debug "Linking api_request #{api_request.id} with correlation #{correlation.id} - corralated by #{correlator_name}"
    {{year, month, day}, {hour, minute, second}} = Chronos.now

    correlated_at = %Ecto.DateTime{year: year, month: month, day: day, hour: hour, min: minute, sec: second}

    api_request = %{api_request | correlation: correlation, correlator_name: correlator_name, correlated_at: correlated_at}
    Repo.update api_request
    api_request
  end
end
