defmodule ReInspector.Backend.ApiRequestControllerTest do
  use ExUnit.Case
  use PlugHelper

  import Mock

  # get /api/api_requests/:id
  test_with_mock "GET /api/api_requests/:id sends the request", ReInspector.App.Services.ApiRequestService, mock_find do
    assert send_request.state == :sent
  end

  test_with_mock "GET /api/api_requests/:id sets the status to 200", ReInspector.App.Services.ApiRequestService, mock_find do
    assert send_request.status == 200
  end

  test_with_mock "GET /api/api_requests/:id sets the content type", ReInspector.App.Services.ApiRequestService, mock_find do
    content_type = Plug.Conn.get_resp_header(send_request, "content-type") |> List.first

    assert content_type == "application/json; charset=utf-8"
  end

  test_with_mock "renders the api request", ReInspector.App.Services.ApiRequestService, mock_find do
    body = send_request.resp_body

    assert Regex.match?(~r/{"api_request"/, body)
  end

  test_with_mock "GET /api/api_requests/not_found sends the request", ReInspector.App.Services.ApiRequestService, mock_find do
    assert send_not_found_request.state == :sent
  end

  test_with_mock "GET /api/api_requests/not_found sets the status to 404", ReInspector.App.Services.ApiRequestService, mock_find do
    assert send_not_found_request.status == 404
  end

  test_with_mock "GET /api/api_requests/not found sets the content type", ReInspector.App.Services.ApiRequestService, mock_find do
    content_type = Plug.Conn.get_resp_header(send_not_found_request, "content-type") |> List.first

    assert content_type == "application/json; charset=utf-8"
  end

  test_with_mock "renders a not found response", ReInspector.App.Services.ApiRequestService, mock_find do
    body = send_not_found_request.resp_body

    assert body == "{}"
  end

  defp send_request,           do: simulate_request(:get, "/api/api_request/10")
  defp send_not_found_request, do: simulate_request(:get, "/api/api_request/20")

  defp mock_find do
    [
      find: fn(id) ->
        case id do
          10 -> %ReInspector.ApiRequest{service_name: "name", correlation: %ReInspector.Correlation{correlations: []}}
          _  -> nil
        end
      end
    ]
  end
end
