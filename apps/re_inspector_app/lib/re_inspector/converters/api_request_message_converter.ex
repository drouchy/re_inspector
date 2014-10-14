defmodule ReInspector.App.Converters.ApiRequestMessageConverter do
  require Logger
  alias ReInspector.App.JsonParser

  def to_postgres(message) do
    Logger.debug fn -> "converting message #{inspect message}" end
    message
    |> Map.put(:requested_at,    parse_date_time(message[:requested_at]))
    |> Map.put(:duration,        message[:time_to_execute])
    |> Map.put(:service_name,    message[:service][:name])
    |> Map.put(:service_version, message[:service][:version])
    |> Map.put(:service_env,     message[:service][:environment])

    |> Map.put(:request_body,    message[:request][:body])
    |> Map.put(:request_headers, JsonParser.encode(message[:request][:headers]))
    |> Map.put(:method,          message[:request][:method])
    |> Map.put(:path,            message[:request][:path])

    |> Map.put(:response_body,    message[:response][:body])
    |> Map.put(:response_headers, JsonParser.encode(message[:response][:headers]))
    |> Map.put(:status,           message[:response][:status])

    |> Map.drop([:service, :request, :response])
  end

  defp parse_date_time date_string do
    Regex.named_captures(~r/^(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})T(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})(?<timezone>.*)/, date_string)
    |> date_time_captures_to_date_time
  end

  defp date_time_captures_to_date_time captures do
    %Ecto.DateTime{year:  String.to_integer(captures["year"]),
                   month: String.to_integer(captures["month"]),
                   day:   String.to_integer(captures["day"]),
                   hour:  String.to_integer(captures["hour"]),
                   min:   String.to_integer(captures["minute"]),
                   sec:   String.to_integer(captures["second"])}
  end
end
