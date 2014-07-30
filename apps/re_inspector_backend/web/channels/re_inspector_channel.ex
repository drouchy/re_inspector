defmodule ReInspector.Backend.Channels.ReInspectorChannel do
  use Phoenix.Channel

  alias ReInspector.App.Services.UserService

  def join(socket, "api_request", message) do
    case UserService.find_by_token(message["authentication"]) do
      nil -> {:error, socket, :unauthorized}
      _   -> {:ok, socket}
    end
  end

  def join(socket, _no, _message) do
    {:error, socket, :unauthorized}
  end
end