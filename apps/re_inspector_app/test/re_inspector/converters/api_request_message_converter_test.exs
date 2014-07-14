defmodule ReInspector.App.Processors.ApiRequestMessageConverterTest do
  use ExUnit.Case

  alias ReInspector.App.Processors.ApiRequestMessageConverter

  test "it converts the requested_at" do
    date = convert[:requested_at]

    assert date.year == 2014
    assert date.month == 1
    assert date.day == 3

    assert date.hour == 14
    assert date.min == 30
    assert date.sec == 00
  end

  test "it converts the time_to_execute" do
    assert convert[:duration] == 1230
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

  test "it converts the request method" do
    assert convert[:method] == "POST"
  end

  test "it converts the request path" do
    assert convert[:path] == "/bookings"
  end

  test "it converts the request headers" do
    assert convert[:request_headers] == "{\"Authorization\":\"Bearer 234......4\",\"Content-type\":\"application/json\"}"
  end

  test "it converts the request body" do
    assert convert[:request_body] == "{ \"booking\" : { \"quote_id\": \"1a2b3c-asap\", \"booking_type\": \"general\" } }"
  end

  test "it converts the response status" do
    assert convert[:status] == 200
  end

  test "it converts the response " do
    assert convert[:response_headers] == "{\"content-type\":\"application/json\"}"
  end

  test "it converts the response body" do
    assert convert[:response_body] == "{ \"booking\": { \"reference\": \"SHU31-24C43\" } }"
  end

  test "it removes the request entry" do
    refute Map.has_key?(convert, :request)
  end

  test "it removes the response entry" do
    refute Map.has_key?(convert, :response)
  end

  test "it removes the service entry" do
    refute Map.has_key?(convert, :service)
  end

  defp convert do
    {:ok, content} = default_fixture
    ReInspector.App.JsonParser.decode(content)
    |> ApiRequestMessageConverter.to_postgres
  end

  defp default_fixture, do: File.read fixture_file
  defp fixture_file,    do: Path.expand("../../../fixtures/booking_requests/default_request.json", __ENV__.file())
end
