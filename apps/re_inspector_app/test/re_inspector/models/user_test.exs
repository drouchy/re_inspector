defmodule ReInspector.UserTest do
  use ExUnit.Case

  alias ReInspector.User

  #obfuscate/1
  test "obfuscate a token" do
    obfuscated = User.obfuscate "abcdefghijklmnopqrstuvwxyz"

    assert obfuscated == "abcd...................xyz"
  end

  test "does not do anything with a nil value" do
    assert User.obfuscate(nil) == nil
  end
end