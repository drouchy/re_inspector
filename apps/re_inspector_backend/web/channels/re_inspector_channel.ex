defmodule ReInspector.Backend.Channels.ReInspectorChannel do
  use Phoenix.Channel
  import Lager

  alias ReInspector.App.Services.UserService

  def join(socket, "api_request", message) do
    case UserService.find_by_token(message["authentication"]) do
      nil ->
        Lager.debug "unauthorized connection: '#{message["authentication"]}'"
        {:error, socket, :unauthorized}
      _   ->
        Lager.debug "successful connection: '#{message["authentication"]}'"
        {:ok, socket}
    end
  end

  def join(socket, _no, _message) do
    Lager.debug "unauthorized connection to unknown topic"
    {:error, socket, :unauthorized}
  end
end