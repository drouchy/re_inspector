defmodule ReInspector.Backend.Authentication.Github do
  require Logger
  use HTTPoison.Base

  alias ReInspector.App.JsonParser

  def authorization_url(config) do
    client_id = config[:client_id]
    random = ReInspector.Random.generate

    "https://github.com/login/oauth/authorize?client_id=#{client_id}&state=#{random}&scope=user"
  end

  def request_access_token(config, code) do
    response = access_token_url(config, code)
    |> post('', [{"Accept", "application/json"}])

    JsonParser.decode(response.body)[:access_token]
  end

  def get_user_info(config, access_token) do
    response = HTTPoison.get("https://api.github.com/user", [{"Accept", "application/json"}, {"Authorization", "token #{access_token}"}])

    JsonParser.decode response.body
  end

  def get_user_orgs(config, access_token, url) do
    response = HTTPoison.get(url, [{"Accept", "application/json"}, {"Authorization", "token #{access_token}"}])

    JsonParser.decode response.body
  end

  defp access_token_url(config, code) do
    params = URI.encode_query %{
      client_id: config[:client_id],
      client_secret: config[:client_secret],
      redirect_uri: config[:redirect_uri],
      code: code
    }

    "login/oauth/access_token?#{params}"
  end

  #httpoison methods
  def process_url(url) do
    "https://github.com/" <> url
  end
end