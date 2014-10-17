defmodule ReInspector.Backend do
  use Application

  def start(), do: start(nil, nil)
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []
    opts = [strategy: :one_for_one, name: ReInspector.Backend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
