defmodule ReInspector.Backend.Services.AuthenticationService do
  import Lager

  alias ReInspector.Backend.Authentication.Github
  alias ReInspector.App.Services.UserService

  def authenticate(provider, params) do
    Lager.info "authenticating #{inspect params} using provider #{provider}"
    access_token = Github.request_access_token(config, params["code"])
    info = Github.get_user_info(config, access_token)

    UserService.create(%{login: info[:login], email: info[:email], access_token: access_token})
  end

  defp config, do: Application.get_all_env(:github)
end