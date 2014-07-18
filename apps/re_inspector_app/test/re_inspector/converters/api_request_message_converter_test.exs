defmodule ReInspector.App.Converters.ApiRequestMessageConverterTest do
  use ExUnit.Case
  import ReInspector.Support.Fixtures

  alias ReInspector.App.Converters.ApiRequestMessageConverter

  test "it converts the requested_at" do
    assert_date convert[:requested_at]
  end

  test "it supports request_at with the +00:00" do
    message = %{default_message| requested_at: "2014-01-03T14:30:00+00:00"}

    converted = ApiRequestMessageConverter.to_postgres(message)

    assert_date converted[:requested_at]
  end

  test "it supports request_at with the +0000" do
    message = %{default_message| requested_at: "2014-01-03T14:30:00+0000"}

    converted = ApiRequestMessageConverter.to_postgres(message)

    assert_date converted[:requested_at]
  end

  test "it converts the time_to_execute" do
    assert convert[:duration] == 1230
  end

  test "it converts the service name" do
    assert convert[:service_name] == "service 1"
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
    assert convert[:path] == "/article/123/comments"
  end

  test "it converts the request headers" do
    assert convert[:request_headers] == "{\"Authorization\":\"Bearer 234......4\",\"Content-type\":\"application/json\"}"
  end

  test "it converts the request body" do
    assert convert[:request_body] == "{ \"comment\" : { \"comment_id\": \"1a2b3c\", \"text\": \"general comment\" } }"
  end

  test "it converts the response status" do
    assert convert[:status] == 200
  end

  test "it converts the response " do
    assert convert[:response_headers] == "{\"content-type\":\"application/json\"}"
  end

  test "it converts the response body" do
    assert convert[:response_body] == "{ \"comment\": { \"reference\": \"24C43\" } }"
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

  defp convert, do: default_message

  def assert_date(date) do
    assert date.year == 2014
    assert date.month == 1
    assert date.day == 3

    assert date.hour == 14
    assert date.min == 30
    assert date.sec == 00
  end
end
