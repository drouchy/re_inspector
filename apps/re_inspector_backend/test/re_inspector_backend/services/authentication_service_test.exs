defmodule ReInspector.Backend.Services.AuthenticationServiceTest do
  use ExUnit.Case
  import Mock

  import ReInspector.Support.Ecto
  import Ecto.Query

  alias ReInspector.User
  alias ReInspector.Repo

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  alias ReInspector.Backend.Services.AuthenticationService
  alias ReInspector.Backend.Authentication.Github

  test_with_mock "create an user with its information & token", Github, github_mock do
    authenticate

    user = from(u in User, where: u.access_token == "ACCESS_TOKEN") |> Repo.all |> List.first
    assert user != nil
    assert user.login == login
    assert user.email == "user_name@example.com"
  end

  test_with_mock "returns the user generated with the token from github", Github, github_mock do
    user = authenticate

    assert user.access_token == access_token
  end

  defp github_mock do
    [
      request_access_token: fn (config, code) -> access_token end,
      get_user_info: fn (config, access_token) -> %{login: login, email: "user_name@example.com", organisations_url: org_url} end,
      get_user_orgs: fn (config, access_token, org_url) -> [%{login: "org1"}, %{login: "org2"}] end
    ]
  end

  defp authenticate, do: AuthenticationService.authenticate("github", %{"code" => code, "state" => "whatever"})

  defp config, do: %{}
  defp access_token, do: "ACCESS_TOKEN"
  defp login, do: "user_name"
  defp org_url, do: "org url"
  defp code, do: "code_send_by_github"
end
