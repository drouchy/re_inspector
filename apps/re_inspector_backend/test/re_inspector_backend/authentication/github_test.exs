defmodule ReInspector.Backend.Authentication.GithubTest do
  use ExUnit.Case
  import Mock
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ReInspector.Backend.Authentication.Github

  #authorization_url/1
  test_with_mock "build the authorization_url with the config & a random number", ReInspector.Random, [generate: fn() -> "46005663142823252" end] do
    url = Github.authorization_url(config)

    assert url == "https://github.com/login/oauth/authorize?client_id=myclient_id&state=46005663142823252&scope=user"
  end

  #request_access_token/2
  test "makes a POST to github to generate a token" do
    use_cassette "generate_token" do
      access_token = Github.request_access_token(config, code)

      assert access_token == recorded_access_token
    end
  end

  #get_user_info/3
  test "makes a GET to github to get the user info" do
    use_cassette "user_info" do
      user_info = Github.get_user_info(config, recorded_access_token, "user")

      assert user_info[:login] == "username"
      assert user_info[:organizations_url] == "https://api.github.com/users/username/orgs"
    end
  end

  #get_user_orgs/3
  test "makes a GET to github to get the user orginazations" do
    use_cassette "user_org" do
      user_orgs = Github.get_user_orgs(config, recorded_access_token, "https://api.github.com/users/username/orgs")

      assert Enum.map(user_orgs, fn(org) -> org[:login] end) == ["org1", "myorg"]
    end
  end

  defp config, do: %{client_id: "myclient_id", client_secret: "myclientsecret", callback_url: "http://re_inspector.example.com"}
  defp code, do: "a81486ef2d03cf40a1f8"
  defp recorded_access_token, do: "0000111122223333444455556666777788889999"
end