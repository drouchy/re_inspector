defmodule ReInspector.Backend.Worker do
  use GenServer

  def start_link() do
     GenServer.start_link(__MODULE__, [], [name: :router_worker])
  end

  def init(_) do
    { ReInspector.Backend.Router.start, :state }
  end
end
