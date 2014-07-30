defmodule ReInspector.Backend do
  use Application

  def start(), do: start(nil, nil)
  def start(_type, _args) do
    { :ok, pid} = ReInspector.Backend.Supervisor.start_link
    ReInspector.Backend.Router.start
    {:ok, pid}
  end
end
