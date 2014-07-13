defmodule ReInspector.App.Services.ApiRequestServiceTest do
  use ExUnit.Case
  import Lager
  import ReInspector.Support.Ecto

  alias ReInspector.App.Services.ApiRequestService
  alias ReInspector.App.Repo

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  #persist/1
  test "it creates an api request with the attributes" do
    request = ApiRequestService.persist(attributes)

    assert request.method == "POST"
  end

  test "it assigns an id" do
    request = ApiRequestService.persist(attributes)

    assert request.id != nil
  end

  test "it persist in the db" do
    ApiRequestService.persist(attributes)

    assert count_api_requests == 1
    assert first_api_request.method == "POST"
  end


  defp attributes, do: %{method: "POST", path: "/url/1"}
end
