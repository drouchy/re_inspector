defmodule ReInspector.Backend do
  use Application

  def start(_type, _args) do
    Plug.Adapters.Cowboy.http(ReInspector.Backend.Router, [], [compress: true])
  end
end
