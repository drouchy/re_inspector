defmodule ReInspector.App.Connections.Redis do
  import Exredis
  require Logger

  def client(opts) do
    Logger.debug "Connection to #{inspect(opts)}"
    start(opts[:host], opts[:port])
  end

  def length(redis_client, list) do
    redis_client
    |> query(["LLEN", list])
    |> to_size
  end

  def pop(redis_client, list) do
    redis_client
    |> query(["BRPOP", list, "1"])
    |> to_message
  end

  def push(redis_client, message, list) do
    redis_client
    |> query(["LPUSH", list, message])
    :ok
  end

  defp to_size(value) do
    case Integer.parse value do
      :error                -> :invalid
      { value, _remainder } -> value
    end
  end

  defp to_message(:undefined), do: :none
  defp to_message([key,value]), do: to_message(value)
  defp to_message(value) do
    case Regex.run ~r/^ERR|WRONG.*/, value do
      nil -> value
      _   -> :none
    end
  end
end
