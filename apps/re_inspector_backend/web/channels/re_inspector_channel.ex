defmodule ReInspector.Backend.Channels.ReInspectorChannel do
  use Phoenix.Channel
  require Logger

  alias ReInspector.App.Services.UserService

  def join(socket, "api_request", message) do
    case UserService.find_by_token(message["authentication"]) do
      nil ->
        Logger.debug "unauthorized connection: '#{message["authentication"]}'"
        {:error, socket, :unauthorized}
      _   ->
        Logger.debug "successful connection: '#{message["authentication"]}'"
        {:ok, socket}
    end
  end

  def join(socket, _no, _message) do
    Logger.debug "unauthorized connection to unknown topic"
    {:error, socket, :unauthorized}
  end
end