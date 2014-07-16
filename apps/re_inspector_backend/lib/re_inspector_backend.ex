defmodule ReInspector.Backend do
  use Application
  import Lager

  def start(_type, _args) do
    Lager.info "Starting web server on port #{Application.get_env(:web, :port)}"
    Plug.Adapters.Cowboy.http(ReInspector.Backend.Router, [], Application.get_all_env(:web))
  end
end
