defmodule ReInspector.App.JsonParser do
  require Logger
  use Jazz

  def decode(message) do
    Logger.debug "parsing message #{message}"
    case JSON.decode(message, keys: :atoms) do
      { :ok, dict} -> dict
      _            -> :invalid
    end
  end

  def encode(dict) do
    Logger.debug "generating json #{inspect(dict)}"
    { :ok, string } = JSON.encode dict
    string
  end

end
