defmodule ReInspector.Backend do
  use Application

  def start(), do: start(nil, nil)
  def start(_type, _args) do
    ReInspector.Backend.Supervisor.start_link
  end
end
