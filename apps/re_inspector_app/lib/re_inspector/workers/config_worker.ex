defmodule ReInspector.App.Workers.ConfigWorker do
  use GenServer

  alias ReInspector.App.Config

  @doc """
  Starts the config worker.
  """
  def start_link() do
     GenServer.start_link(__MODULE__, [], [name: :re_inspector_config])
  end

  def handle_call(:version, {_from, _ref}, state) do
    { :reply, Config.version, state }
  end
end
