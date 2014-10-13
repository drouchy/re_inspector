defmodule ReInspector.App.Services.UserService do
  require Logger
  import Ecto.Query, only: [from: 2]

  alias ReInspector.Repo

  def create(attributes) do
    Logger.debug("inserting user: #{inspect attributes}")

    attributes = Map.merge(attributes, %{created_at: now, updated_at: now})
    struct(ReInspector.User, attributes)
    |> Repo.insert
  end

  def update(user, attributes) do
    Logger.debug("updating user: #{inspect user.id} with #{inspect attributes}")

    user = Map.merge(user, attributes) |> Map.put(:updated_at, now)
    :ok = user |> Repo.update
    user
  end

  def find_by_token(token) do
    Logger.debug("find user by token #{obfuscate token}")
    first_result from(u in ReInspector.User, where: u.access_token == ^token)
  end

  def find_by_login(login) do
    Logger.debug("find user by login #{login}")
    first_result from(u in ReInspector.User, where: u.login == ^login)
  end

  defp obfuscate(value) do
    value
  end

  defp first_result(query) do
    query
    |> Repo.all
    |> List.first
  end
  def now, do: Ecto.DateTime.from_erl Chronos.now
end