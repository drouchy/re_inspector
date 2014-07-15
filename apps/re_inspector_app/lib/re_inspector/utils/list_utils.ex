defmodule ReInspector.App.Utils.ListUtils do
  def merge(first_list, second_list) do
    merge([], first_list, second_list)
  end

  defp merge(accumulator, [], []), do: Enum.reverse accumulator
  defp merge(accumulator, [element_one|tail_one], [element_two|tail_two]) do
    merge([choose(element_one, element_two) | accumulator], tail_one, tail_two)
  end

  defp choose(nil, element_two), do: element_two
  defp choose(element_one, _element_two), do: element_one
end
