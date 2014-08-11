defmodule ReInspector.App.Processors.RedisListener do
  import Logger

  alias ReInspector.App.Connections.Redis
  alias ReInspector.App.JsonParser

  def listen(redis_client, list) do
    Redis.pop(redis_client, list)
    |> decode
  end

  defp decode(:none), do: :none
  defp decode(message) do
    message
    |> JsonParser.decode
  end
end
