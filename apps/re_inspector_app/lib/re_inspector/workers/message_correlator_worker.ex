defmodule ReInspector.App.Workers.MessageCorrelatorWorker do
  use GenServer
  import Lager

  @doc """
  Starts the config worker.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :re_inspector_message_correlator])
  end

end
