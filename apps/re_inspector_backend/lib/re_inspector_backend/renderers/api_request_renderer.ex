defmodule ReInspector.Backend.Renderers.ApiRequestRenderer do
  import Lager

  def render(api_request) do
    api_request
    |> obfuscate(api_request.correlator_name)
    |> to_map
  end

  defp obfuscate(api_request, nil), do: api_request
  defp obfuscate(api_request, correlator_name) do
    apply(String.to_atom(correlator_name), :obfuscate, [api_request])
  rescue
    e in UndefinedFunctionError -> api_request
  end

  defp to_map(api_request) do
    Lager.debug "rendering: #{inspect api_request}"
    %{
      "requested_at"      => to_iso8601(api_request.requested_at),
      "correlated_at"     => to_iso8601(api_request.correlated_at),
      "duration"          => api_request.duration,
      "request" => %{
        "path"        => api_request.path,
        "method"      => api_request.method,
        "headers"     => api_request.request_headers,
        "body"        => api_request.request_body,
      },
      "response" => %{
        "headers"  => api_request.response_headers,
        "body"     => api_request.response_body,
        "status"   => api_request.status
      },
      "service" => %{
        "name"      => api_request.service_name,
        "version"   => api_request.service_version,
        "env"       => api_request.service_env
      },
      "request_name"      => api_request.request_name,
      "correlator_name"   => api_request.correlator_name
    }
  end

  defp to_iso8601(nil), do: nil
  defp to_iso8601(datetime) do
    "#{format_date(datetime)}T#{format_time(datetime)}Z"
  end

  defp format_date(datetime) do
    "#{format_number(datetime.year)}-#{format_number(datetime.month)}-#{format_number(datetime.day)}"
  end

  defp format_time(datetime) do
    "#{format_number(datetime.hour)}:#{format_number(datetime.min)}:#{format_number(datetime.sec)}"
  end

  defp format_number(num) when num < 10 do
    "0#{num}"
  end
  defp format_number(num), do: "#{num}"
end