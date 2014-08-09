defmodule ReInspector.App.Workers.MessageBroadcasterWorker do
  use GenServer
  import Lager

  @doc """
  Starts the config worker.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :re_inspector_message_broadcaster])
  end

  def handle_cast({:new_request, api_request_id}, state) do
    Lager.debug "broadcasting 'new_request' for api request id #{api_request_id}"

    case Application.get_env(:re_inspector_app, :broadcast_command) do
      nil      -> nil
      function -> function.(api_request_id)
    end

    {:noreply, state}
  end

end
