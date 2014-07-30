defmodule ReInspector.Backend.Channels.ReInspectorChannelTest do
  use ExUnit.Case
  import Mock

  alias ReInspector.Backend.Channels.ReInspectorChannel
  alias ReInspector.App.Services.UserService

  #join/3
  test_with_mock "returns ok when the user can be found with the provided token", UserService, mock_authentication do
     {:ok, socket} = ReInspectorChannel.join(:socket, "api_request", %{"authentication" => "VALID_TOKEN"})
  end

  test_with_mock "returns unauthenticated when there is no token provided", UserService, mock_authentication do
     {:error, socket, :unauthorized} = ReInspectorChannel.join(:socket, "api_request", %{})
  end

  test_with_mock "returns unauthenticated when there the token is not found", UserService, mock_authentication do
     {:error, socket, :unauthorized} = ReInspectorChannel.join(:socket, "api_request", %{"authentication" => "INVALID_TOKEN"})
  end

  test_with_mock "returns unauthenticated when the topic is invalid", UserService, mock_authentication do
     {:error, socket, :unauthorized} = ReInspectorChannel.join(:socket, "other_topic", %{})
  end

  def mock_authentication do
    [
      find_by_token: fn(token) ->
        case token do
          "VALID_TOKEN"   -> %ReInspector.User{login: "user 1"}
          "INVALID_TOKEN" -> nil
          nil             -> nil
        end
      end
    ]
  end
end