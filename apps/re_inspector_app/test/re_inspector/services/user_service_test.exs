defmodule ReInspector.App.Services.UserServiceTest do
  use ExUnit.Case

  import ReInspector.Support.Ecto
  import Ecto.Query, only: [from: 2]

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  alias ReInspector.App.Services.UserService
  alias ReInspector.Repo

  #create/1
  test "creates the value in the db" do
    user = %{login: "user test", token: "one token"}

    UserService.create(user)

    user = Repo.all(from u in ReInspector.User, where: u.token == "one token") |> List.first
    assert user != nil
    assert user.login == "user test"
  end

  #update/1
  test "inserts the value in the db" do
    user = %ReInspector.User{login: "user test", token: "one token"} |> Repo.insert
    attributes = %{token: "new token"}

    UserService.update(user, attributes)

    user = Repo.all(from u in ReInspector.User, where: u.token == "new token") |> List.first
    assert user != nil
    assert user.login == "user test"
  end

  #find_ty_token/1
  test "checks the entry in the db" do
    user = %ReInspector.User{login: "user test", token: "one token"} |> Repo.insert

    user = UserService.find_by_token("one token")

    assert user != nil
    assert user.login == "user test"
  end

  test "returns nil if not found in the db" do
    user = %ReInspector.User{login: "user test", token: "one token"} |> Repo.insert

    user = UserService.find_by_token("other token")

    assert user == nil
  end
end