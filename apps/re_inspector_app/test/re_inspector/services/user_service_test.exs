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
    user = %{login: "user test", access_token: "one token"}

    UserService.create(user)

    user = Repo.all(from u in ReInspector.User, where: u.access_token == "one token") |> List.first
    assert user != nil
    assert user.login == "user test"
  end

  test "creating sets the created_at" do
    user = %{login: "user test", access_token: "one token"}

    user = UserService.create(user)
    assert user.created_at != nil
  end

  test "creating sets the updated_at" do
    user = %{login: "user test", access_token: "one token"}

    user = UserService.create(user)
    assert user.created_at != nil
  end

  #update/1
  test "inserts the value in the db" do
    user = %ReInspector.User{login: "user test", access_token: "one token"} |> Repo.insert
    attributes = %{access_token: "new token"}

    UserService.update(user, attributes)

    user = Repo.all(from u in ReInspector.User, where: u.access_token == "new token") |> List.first
    assert user != nil
    assert user.login == "user test"
  end

  test "returns the updated value" do
    user = %ReInspector.User{login: "user test", access_token: "one token"} |> Repo.insert
    attributes = %{access_token: "new token"}

    user = UserService.update(user, attributes)

    assert user.login == "user test"
  end

  test "insertion update the updated_at" do
    user = %ReInspector.User{login: "user test", access_token: "one token", updated_at: now, created_at: now} |> Repo.insert
    attributes = %{access_token: "new token"}

    # TODO: find a better way
    :timer.sleep 1100
    updated = UserService.update(user, attributes)

    assert updated.created_at == user.created_at
    refute updated.updated_at == user.updated_at
  end

  #find_by_token/1
  test "checks the entry in the db" do
    %ReInspector.User{login: "user test", access_token: "one token"} |> Repo.insert

    user = UserService.find_by_token("one token")

    assert user != nil
    assert user.login == "user test"
  end

  test "returns nil if not found in the db" do
    %ReInspector.User{login: "user test", access_token: "one token"} |> Repo.insert

    user = UserService.find_by_token("other token")

    assert user == nil
  end

  #find_by_login/1
  test "checks the entry in the db for the login" do
    %ReInspector.User{login: "user test", access_token: "one token"} |> Repo.insert

    user = UserService.find_by_login("user test")

    assert user != nil
    assert user.access_token == "one token"
  end

  test "returns nil if no login found in the db" do
    %ReInspector.User{login: "user test", access_token: "one token"} |> Repo.insert

    user = UserService.find_by_login("other user")

    assert user == nil
  end

  def now, do: Ecto.DateTime.from_erl Chronos.now
end