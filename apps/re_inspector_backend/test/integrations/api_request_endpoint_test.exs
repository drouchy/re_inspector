defmodule ReInspector.Backend.Integration.ApiRequestTest do
  use IntegrationTest.Case

  import ReInspector.Backend.Fixtures
  import ReInspector.Support.Ecto

  #show/2
  test "renders the api request" do
    api_request_id = insert_one_fixture

    body = fetch "/api/api_request/#{api_request_id}"
    body = ReInspector.App.JsonParser.decode body

    assert body[:api_request] != nil
    assert body[:api_request][:service][:name] == "service 1"
  end

end
