defmodule ReInspector.App do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(ReInspector.App.Workers.ConfigWorker, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReInspector.App.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def version do
    GenServer.call(:re_inspector_config, :version)
  end
end
