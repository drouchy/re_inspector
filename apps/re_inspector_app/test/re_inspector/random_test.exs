defmodule ReInspector.RandomTest do
  use ExUnit.Case

  test "generates a different number everytime - hopefully" do
    generated = Enum.map(0..100, fn(_) -> ReInspector.Random.generate end)

    assert Enum.uniq(generated) == generated
  end
end