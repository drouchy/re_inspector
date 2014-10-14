defmodule ReInspector.App.Services.UserService do
  require Logger
  import Ecto.Query, only: [from: 2]

  alias ReInspector.Repo

  def create(attributes) do
    Logger.debug fn -> "inserting user: #{inspect attributes}" end

    attributes = Map.merge(attributes, %{created_at: now, updated_at: now})
    struct(ReInspector.User, attributes)
    |> Repo.insert
  end

  def update(user, attributes) do
    Logger.debug fn -> "updating user: #{inspect user.id} with #{inspect attributes}" end

    user = Map.merge(user, attributes) |> Map.put(:updated_at, now)
    :ok = user |> Repo.update
    user
  end

  def find_by_token(token) do
    Logger.debug fn -> "find user by token #{obfuscate token}" end
    first_result from(u in ReInspector.User, where: u.access_token == ^token)
  end

  def find_by_login(login) do
    Logger.debug fn -> "find user by login #{login}" end
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