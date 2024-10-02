defmodule GildedRose do
  defp increase_quality(item, amount), do: %{item | quality: min(50, item.quality + amount)}

  defp decrease_quality(item, amount), do: %{item | quality: max(0, item.quality - amount)}

  defp update_sell_in(item), do: %{item | sell_in: item.sell_in - 1}

  defp update_quality(item = %{name: name, sell_in: sell_in}, factor) do
    case name do
      "Aged Brie" -> increase_quality(item, factor)
      "Backstage passes"<>_ -> cond do
        sell_in < 1 -> %{item | quality: 0}
        sell_in < 6 -> increase_quality(item, 3)
        sell_in < 11 -> increase_quality(item, 2)
        true -> increase_quality(item, 1)
      end
      "Conjured"<>_ -> decrease_quality(item, 2 * factor)
      _ -> decrease_quality(item, factor)
    end
  end

  defp update_quality(item) when item.sell_in < 1, do: update_quality(item, 2)
  defp update_quality(item), do: update_quality(item, 1)

  defp update_item(item = %{name: "Sulfuras"<>_}), do: item
  defp update_item(item), do: item |> update_quality |> update_sell_in

  def update_items(items), do: Enum.map(items, &update_item/1)

end
