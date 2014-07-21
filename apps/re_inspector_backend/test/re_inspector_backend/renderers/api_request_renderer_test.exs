defmodule ReInspector.Backend.Renderers.ApiRequestRendererTest do
  use ExUnit.Case

  alias ReInspector.Backend.Renderers.ApiRequestRenderer

  test "renders the requested_at" do
    assert rendered["requested_at"] == "2014-07-01T14:32:06Z"
  end

  test "renders the correlated_at" do
    assert rendered["correlated_at"] == "2014-07-01T14:40:06Z"
  end

  test "renders the duration" do
    assert rendered["duration"] == 12
  end

  test "renders the path" do
    assert rendered["request"]["path"] == "/path"
  end

  test "renders the method" do
    assert rendered["request"]["method"] == "get"
  end

  test "renders the request_headers" do
    assert rendered["request"]["headers"] == "request headers"
  end

  test "renders the request_body" do
    assert rendered["request"]["body"] == "request body"
  end

  test "renders the response_headers" do
    assert rendered["response"]["headers"] == "response headers"
  end

  test "renders the response_body" do
    assert rendered["response"]["body"] == "response body"
  end

  test "renders the status" do
    assert rendered["response"]["status"] == 200
  end

  test "renders the service_name" do
    assert rendered["service"]["name"] == "service name"
  end

  test "renders the service_version" do
    assert rendered["service"]["version"] == "service version"
  end

  test "renders the service_env" do
    assert rendered["service"]["env"] == "service env"
  end

  test "renders the request_name" do
    assert rendered["request_name"] == "request name"
  end

  test "renders the correlator_name" do
    assert rendered["correlator_name"] == "Elixir.ReInspector.Test.Service2Correlator"
  end

  test "before rendering obfuscates the message with the correlator" do
    message = %{fixture | correlator_name: "Elixir.ReInspector.Test.Service1Correlator"}

    obfuscated = ApiRequestRenderer.render message

    assert obfuscated["request"]["headers"] == "REDACTED"
  end

  test "does not crash if the correlator can not be found" do
    message = %{fixture | correlator_name: "Elixir.ReInspector.Test.ServiceUnkownCorrelator"}

    obfuscated = ApiRequestRenderer.render message

    assert obfuscated["request"]["headers"] == "request headers"
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
      correlator_name: "Elixir.ReInspector.Test.Service2Correlator"
    }
  end
end