defmodule ReInspector.App.Utils.ListUtils do
  def merge(first_list, second_list) do
    case pre_check?(first_list, second_list) do
      true  -> merge([], first_list, second_list)
      false -> :unmergeable
    end
  end

  defp pre_check?(first_list, second_list) do
    first_list
    |>Enum.with_index
    |>Enum.map(fn ({value,index}) -> Enum.at(second_list, index) == value end)
    |>Enum.any?
  end

  defp merge(accumulator, [], []), do: Enum.reverse accumulator
  defp merge(accumulator, [element_one|tail_one], [element_two|tail_two]) do
    case choose(element_one, element_two) do
      :incompatible -> :unmergeable
      chosen        -> merge([chosen | accumulator], tail_one, tail_two)
    end
  end

  defp choose(nil, element_two),           do: element_two
  defp choose(element_one, nil),           do: element_one
  defp choose(element_one, element_one),   do: element_one
  defp choose(_element_one, _element_two), do: :incompatible
end
