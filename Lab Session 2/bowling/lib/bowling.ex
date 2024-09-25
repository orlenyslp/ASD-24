defmodule Bowling do

  def score(game) do
    List.flatten(game)
    |> Enum.filter(fn e -> is_number(e) end)
    |> total_score()
  end

  defp total_score(game), do: Enum.sum(game) + bonus(game)

  defp bonus([]), do: 0
  defp bonus([_, _, _]), do: 0
  defp bonus([10 | tail]), do: hd(tail) + Enum.at(tail, 1) + bonus(tail)
  defp bonus([h1, h2 | tail]) when h1 + h2 == 10, do: hd(tail) + bonus(tail)
  defp bonus([_, _ | tail]), do: bonus(tail)

end
