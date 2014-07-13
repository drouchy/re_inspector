defmodule ReInspector.App.Connections.Redis do
  import Exredis
  require Lager

  def client(opts) do
    Lager.debug "Connection to #{inspect(opts)}"
    start(to_char_list(opts[:host]), opts[:port])
  end

  def length(redis_client, list) do
    Lager.debug "length of the list #{list}"
    redis_client
    |> query(["LLEN", list])
    |> to_size
  end

  def pop(redis_client, list) do
    Lager.debug "lpop of the list #{list}"
    redis_client
    |> query(["BLPOP", list, "0"])
    |> value
  end

  def push(redis_client, message, list) do
    Lager.debug "push #{message}"
    redis_client
    |> query(["RPUSH", list, message])
    :ok
  end

  defp to_size(value) do
    case Integer.parse value do
      :error                -> :invalid
      { value, _remainder } -> value
    end
  end

  defp value([_name, value]), do: value
  defp value(_), do: :none
end
