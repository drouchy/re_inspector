defmodule ReInspector.Backend.Renderers.ApiRequestRenderer do
  import Logger

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
    Logger.debug "rendering: #{inspect api_request}"
    %{
      "id"                => api_request.id,
      "requested_at"      => to_iso8601(api_request.requested_at),
      "correlated_at"     => to_iso8601(api_request.correlated_at),
      "duration"          => api_request.duration,
      "correlations"      => compact(ReInspector.ApiRequest.correlations(api_request)),

      "request" => %{
        "path"        => api_request.path,
        "method"      => api_request.method,
        "headers"     => decode_headers(api_request.request_headers),
        "body"        => api_request.request_body,
      },
      "response" => %{
        "headers"  => decode_headers(api_request.response_headers),
        "body"     => api_request.response_body,
        "status"   => api_request.status
      },
      "service" => %{
        "name"      => api_request.service_name,
        "version"   => api_request.service_version,
        "env"       => api_request.service_env
      },
      "request_name"           => api_request.request_name,
      "correlator_name"        => api_request.correlator_name,
      "additional_information" => convert_to_hash(api_request.additional_information)
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

  defp decode_headers(nil), do: %{}
  defp decode_headers(headers_as_string) do
    case ReInspector.App.JsonParser.decode headers_as_string do
      :invalid -> %{}
      hash     -> hash
    end
  end

  defp compact(enum), do: Enum.filter(enum, fn(e) -> e end)

  defp convert_to_hash(nil), do: %{}
  defp convert_to_hash(list) do
    list
    |> Enum.chunk(2)
    |> Enum.reduce(%{}, fn([name, value], accumulator) -> Map.put(accumulator, name, value) end)
  end

end