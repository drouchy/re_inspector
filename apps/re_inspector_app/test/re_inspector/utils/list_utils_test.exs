defmodule ReInspector.App.Utils.ListUtilsTest do
  use ExUnit.Case

  alias ReInspector.App.Utils.ListUtils

  test "fills the nil values from the first list with the second one" do
    list_one = [4, 1, nil, nil]
    list_two = [4, nil, 3, nil]

    assert ListUtils.merge(list_one, list_two) == [4, 1, 3, nil]
  end

  test "returns the first list when the second one contains only nil" do
    list_one = [1, nil, 3]
    list_two = [nil, nil, nil]

    assert ListUtils.merge(list_one, list_two) == list_one
  end

  test "fills the first list when  contains only nil" do
    list_two = [1, nil, 3]
    list_one = [nil, nil, nil]

    assert ListUtils.merge(list_one, list_two) == list_two
  end

  test "returns :unmergeable if the two list are not compatible" do
    list_one = [1, nil, 3]
    list_two = [2, nil, 3]

    assert ListUtils.merge(list_one, list_two) == :unmergeable
  end

  test "returns :unmergeable is the two lists don't have anything in common" do
    list_one = ["24C43", nil, nil]
    list_two = [nil, "24C43", "1234"]

    assert ListUtils.merge(list_one, list_two) == :unmergeable
  end
end
