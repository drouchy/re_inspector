defmodule ReInspector.Backend.Renderers.ApiRequestRendererTest do
  use ExUnit.Case

  alias ReInspector.Backend.Renderers.ApiRequestRenderer

  test "render the requested_at" do
    assert rendered["requested_at"] == "2014-07-01T14:32:06Z"
  end

  test "render the correlated_at" do
    assert rendered["correlated_at"] == "2014-07-01T14:40:06Z"
  end

  test "render the duration" do
    assert rendered["duration"] == 12
  end

  test "render the path" do
    assert rendered["request"]["path"] == "/path"
  end

  test "render the method" do
    assert rendered["request"]["method"] == "get"
  end

  test "render the request_headers" do
    assert rendered["request"]["headers"] == "request headers"
  end

  test "render the request_body" do
    assert rendered["request"]["body"] == "request body"
  end

  test "render the response_headers" do
    assert rendered["response"]["headers"] == "response headers"
  end

  test "render the response_body" do
    assert rendered["response"]["body"] == "response body"
  end

  test "render the status" do
    assert rendered["response"]["status"] == 200
  end

  test "render the service_name" do
    assert rendered["service"]["name"] == "service name"
  end

  test "render the service_version" do
    assert rendered["service"]["version"] == "service version"
  end

  test "render the service_env" do
    assert rendered["service"]["env"] == "service env"
  end

  test "render the request_name" do
    assert rendered["request_name"] == "request name"
  end

  test "render the correlator_name" do
    assert rendered["correlator_name"] == "correlator name"
  end

  defp rendered, do: ApiRequestRenderer.render fixture

  defp fixture do
    %ReInspector.ApiRequest{
      requested_at:  %Ecto.DateTime{year: 2014, month: 7, day: 1, hour: 14, min: 32 ,sec: 6},
      correlated_at: %Ecto.DateTime{year: 2014, month: 7, day: 1, hour: 14, min: 40 ,sec: 6},
      duration: 12,
      path: "/path",
      method: "get",
      request_headers: "request headers",
      request_body: "request body",
      response_headers: "response headers",
      response_body: "response body",
      status: 200,
      service_name: "service name",
      service_version: "service version",
      service_env: "service env",
      request_name: "request name",
      correlator_name: "correlator name"
    }
  end
end