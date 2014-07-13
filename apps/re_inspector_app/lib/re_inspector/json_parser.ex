defmodule ReInspector.App.JsonParser do
  require Lager
  use Jazz

  def decode(message) do
    Lager.debug "parsing message #{message}"
    case JSON.decode(message, keys: :atoms) do
      { :ok, dict} -> dict
      _            -> :invalid
    end
  end

  def encode(dict) do
    Lager.debug "generating json #{inspect(dict)}"
    { :ok, string } = JSON.encode dict
    string
  end

end
