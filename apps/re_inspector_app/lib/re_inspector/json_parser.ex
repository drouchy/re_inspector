defmodule ReInspector.App.JsonParser do
  require Logger
  use Jazz

  def decode(message) do
    Logger.debug fn -> "parsing message #{message}" end
    case JSON.decode(message, keys: :atoms) do
      { :ok, dict} -> dict
      _            -> :invalid
    end
  end

  def encode(dict) do
    Logger.debug fn -> "generating json #{inspect(dict)}" end
    { :ok, string } = JSON.encode dict
    string
  end

end
