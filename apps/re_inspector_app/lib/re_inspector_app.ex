defmodule ReInspector.App do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    ReInspector.App.Supervisors.MainSupervisor.start_link
  end

  def version do
    GenServer.call(:re_inspector_config, :version)
  end
end
