defmodule ReInspector.Backend.BroadcastingService do
  import Lager

  def new_request(api_request_id) do
    Lager.info "Broadcast event 'new request' - #{api_request_id}"
    Phoenix.Channel.broadcast "re_inspector", "api_request", "new:request", %{path: "/api/api_request/#{api_request_id}"}
    {:ok, api_request_id}
  end
end