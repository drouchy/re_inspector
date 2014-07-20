defmodule ReInspector.App.Services.UserService do
  import Lager
  import Ecto.Query, only: [from: 2]

  alias ReInspector.Repo

  def create(attributes) do
    Lager.debug("inserting user: #{inspect attributes}")
    struct(ReInspector.User, attributes)
    |> Repo.insert
  end

  def update(user, attributes) do
    Lager.debug("updating user: #{inspect user.id} with #{inspect attributes}")
    Map.merge(user, attributes) |> Repo.update
  end

  def find_by_token(token) do
    Lager.debug("find user by token #{obfuscate token}")
    from(u in ReInspector.User, where: u.token == ^token)
    |> Repo.all
    |> List.first
  end

  defp obfuscate(value) do
    value
  end
end