defmodule ReInspector.App.Processors.ApiRequestMessageConverter do
  import Lager

  def to_postgres(message) do
    Lager.debug "converting message #{inspect message}"
    message
    |> Map.put(:service_name, message[:service][:name])
    |> Map.put(:service_version, message[:service][:version])
    |> Map.put(:service_env, message[:service][:environment])
    |> Map.drop([:service, :request, :response, :requested_at])
  end
end
