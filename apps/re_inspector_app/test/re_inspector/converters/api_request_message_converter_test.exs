defmodule ReInspector.App.Processors.ApiRequestMessageConverterTest do
  use ExUnit.Case

  alias ReInspector.App.Processors.ApiRequestMessageConverter

  test "it converts the requested_at" do
    assert convert[:requested_at] == "2014-01-03T14:30:00Z"
  end

  test "it converts the time_to_execute" do
    assert convert[:time_to_execute] == 1230
  end

  test "it converts the service name" do
    assert convert[:service_name] == "booking_service"
  end

  test "it converts the service version" do
    assert convert[:service_version] == "4.10.3"
  end

  test "it converts the service environment" do
    assert convert[:service_env] == "sandbox"
  end

  defp convert do
    {:ok, content} = default_fixture
    ReInspector.App.JsonParser.decode(content)
    |> ApiRequestMessageConverter.to_postgres
  end

  defp default_fixture, do: File.read fixture_file
  defp fixture_file,    do: Path.expand("../../../fixtures/booking_requests/default_request.json", __ENV__.file())
end

"""
{

  "request": {
     "method": "POST",
     "path": "/bookings",
     "headers": {
       "Authorization": "Bearer 234......4",
       "Content-type": "application/json"
     },
     "body": "{ \"booking\" : { \"quote_id\": \"1a2b3c-asap\", \"booking_type\": \"general\" } }"
  },
  "response": {
     "status": 200,
     "headers": {
       "content-type": "application/json"
     },
     "body": "{ \"booking\": { \"reference\": \"SHU31-24C43\" } }"
  }
}
"""
