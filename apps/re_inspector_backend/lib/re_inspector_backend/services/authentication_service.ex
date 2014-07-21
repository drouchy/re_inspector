defmodule ReInspector.Backend.Services.AuthenticationService do
  import Lager

  alias ReInspector.Backend.Authentication.Github
  alias ReInspector.App.Services.UserService

  def authenticate(provider, params) do
    Lager.info "authenticating #{inspect params} using provider #{provider}"
    access_token = Github.request_access_token(config, params["code"])
    info = Map.put Github.get_user_info(config, access_token), :provider, provider

    case check_correct_orginsation(config[:organisation], info[:organizations_url], access_token) do
      true -> process_authentication(info, access_token)
      false -> false
    end
  end

  def process_authentication(info, access_token) do
    previous_user = UserService.find_by_login(info[:login])
    process_user_info(previous_user, info, access_token)
  end

  defp process_user_info(nil, info, access_token) do
    UserService.create(%{login: info[:login], email: info[:email], access_token: access_token, authenticated_by: info[:provider]})
  end
  defp process_user_info(existing_user, info, access_token) do
    UserService.update(existing_user, %{access_token: access_token})
  end


  defp config, do: Application.get_all_env(:github)

  defp check_correct_orginsation(nil, login, access_token), do: true
  defp check_correct_orginsation(organisation, url, access_token) do
    Github.get_user_orgs(config, access_token, url)
    |> Enum.map(fn(org) -> org[:login] end)
    |> Enum.member? organisation
  end
end