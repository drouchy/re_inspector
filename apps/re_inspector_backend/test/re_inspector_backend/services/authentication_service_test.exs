defmodule ReInspector.Backend.Services.AuthenticationServiceTest do
  use ExUnit.Case, async: false
  import Mock

  import ReInspector.Support.Ecto
  import Ecto.Query

  alias ReInspector.User
  alias ReInspector.Repo

  setup do
    clean_db
    on_exit fn ->
      Application.put_env(:re_inspector_backend, :github, [client_id: "GITHUB_CLIENT_ID", client_secret: "GITHUB_CLIENT_SECRET"])
      clean_db
    end
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

  test_with_mock "sets the user authentication provider", Github, github_mock do
    authenticate

    user = from(u in User, where: u.access_token == "ACCESS_TOKEN") |> Repo.all |> List.first
    assert user.authenticated_by == "github"
  end

  test_with_mock "returns the user generated with the token from github", Github, github_mock do
    user = authenticate

    assert user.access_token == access_token
  end

  test_with_mock "updates the database if the login already exists", Github, github_mock do
    %User{login: login, access_token: "previous token"} |> Repo.insert

    user = authenticate

    assert count_users == 1
    assert user.access_token == access_token
  end

  test_with_mock "authenticates an user in the correct organisation", Github, github_mock do
    Application.put_env(:re_inspector_backend, :github, [organisation: "org1", client_id: "GITHUB_CLIENT_ID", client_secret: "GITHUB_CLIENT_SECRET"])

    user = authenticate

    assert count_users == 1
  end

  test_with_mock "refuses to authenticate an user not in the correct organisation", Github, github_mock do
    Application.put_env(:re_inspector_backend, :github, [organisation: "org3", client_id: "GITHUB_CLIENT_ID", client_secret: "GITHUB_CLIENT_SECRET"])

    user = authenticate

    assert count_users == 0
  end

  test_with_mock "authenticates an user in any organisation if there is no filter on it", Github, github_mock do
    Application.put_env(:re_inspector_backend, :github, [organisation: nil, client_id: "GITHUB_CLIENT_ID", client_secret: "GITHUB_CLIENT_SECRET"])

    user = authenticate

    assert count_users == 1
  end

  defp github_mock do
    [
      request_access_token: fn (_config, _code) -> access_token end,
      get_user_info: fn (_config, "ACCESS_TOKEN") -> %{login: login, email: "user_name@example.com", organizations_url: "org url"} end,
      get_user_orgs: fn (_config, "ACCESS_TOKEN", "org url") -> [%{login: "org1"}, %{login: "org2"}] end
    ]
  end

  defp authenticate, do: AuthenticationService.authenticate("github", %{"code" => code, "state" => "whatever"})

  defp access_token, do: "ACCESS_TOKEN"
  defp login, do: "user_name"
  defp code, do: "code_send_by_github"

  defp count_users do
    from(u in ReInspector.User, [])
    |> Repo.all
    |> Enum.count
  end
end
