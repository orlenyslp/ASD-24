defmodule GildedRoseTest do
  use ExUnit.Case

  test "At the end of each day our system lowers both values for every item" do
    item = %Item{name: "+5 Dexterity Vest", sell_in: 10, quality: 20}
    [updated_item] = GildedRose.update_items([item])
    assert updated_item.sell_in == item.sell_in - 1
    assert updated_item.quality == item.quality - 1
  end

  test "Once the sell by date has passed, Quality degrades twice as fast" do
    items = [ %Item{name: "+5 Dexterity Vest", sell_in: 0, quality: 20},
              %Item{name: "+5 Dexterity Vest", sell_in: -2, quality: 20} ]
    res = GildedRose.update_items(items)
	# The following 2 tests cases are equivalent
	  assert res == Enum.map(items, fn item -> %Item{item | sell_in: item.sell_in - 1, quality: item.quality - 2} end)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: &1.quality - 2}))
  end

  test "The Quality of an item is never negative" do
    items = [ %Item{name: "+5 Dexterity Vest", sell_in: 0, quality: 1},
              %Item{name: "+5 Dexterity Vest", sell_in: 5, quality: 0},
              %Item{name: "+5 Dexterity Vest", sell_in: 0, quality: 0} ]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: 0}))
  end

  test "Aged Brie actually increases in Quality the older it gets" do
    [i1, i2] = [ %Item{name: "Aged Brie", sell_in: 0, quality: 10},
                 %Item{name: "Aged Brie", sell_in: 5, quality: 20} ]
    res = GildedRose.update_items([i1, i2])

    assert res == [ %{i1 | sell_in: i1.sell_in - 1, quality: i1.quality + 2},
                     %{i2 | sell_in: i2.sell_in - 1, quality: i2.quality + 1}]
  end

  test "The Quality of an item is never more than 50" do
     items = [ %Item{name: "Aged Brie", sell_in: 0, quality: 49},
               %Item{name: "Aged Brie", sell_in: -2, quality: 50},
               %Item{name: "Aged Brie", sell_in: 5, quality: 50} ]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: 50}))
  end

  test "Sulfuras, being a legendary item, never has to be sold or decreases in Quality" do
    items = [ %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 49},
              %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -2, quality: 24},
              %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 5, quality: 10} ]
    res = GildedRose.update_items(items)
    assert res == items
  end

  test "Backstage passes, increases in Quality as it’s SellIn value approaches" do
    [i1, i2] = [ %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 56, quality: 50},
                 %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 11, quality: 26} ]
    res = GildedRose.update_items([i1, i2])
    assert res == [ %{i1 | sell_in: i1.sell_in - 1, quality: 50},
                     %{i2 | sell_in: i2.sell_in - 1, quality: i2.quality + 1}]
  end

  test "Backstage passes, Quality increases by 2 when there are 10 days or less" do
    items = [ %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 26},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 26},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 6, quality: 26}]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: &1.quality + 2}))

    items = [ %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 49},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 50},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 6, quality: 48} ]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: 50}))
  end

  test "Backstage passes, increases in Quality by 3 when there are 5 days or less" do
    items = [ %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 1, quality: 45},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 46},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 3, quality: 20}]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: &1.quality + 3}))

    items = [ %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 1, quality: 49},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 50},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 4, quality: 48} ]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: 50}))
  end

  test "Backstage passes, Quality drops to 0 after the concert" do
    items = [ %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 0, quality: 50},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: -3, quality: 47},
              %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: -3, quality: 20}]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: 0}))
  end

  # @tag :skip
  test "Conjured items degrade in Quality twice as fast as normal items" do
    items = [ %Item{name: "Conjured Mana Cake ", sell_in: 0, quality: 3},
              %Item{name: "Conjured Mana Cake 1", sell_in: -3, quality: 0},
              %Item{name: "Conjured Mana Cake 2", sell_in: 4, quality: 1}]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: 0}))

    items = [ %Item{name: "Conjured Mana Cake ", sell_in: 0, quality: 10},
              %Item{name: "Conjured Mana Cake", sell_in: -2, quality: 33}]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: &1.quality - 4}))

    items = [ %Item{name: "Conjured Mana Cake ", sell_in: 6, quality: 10},
              %Item{name: "Conjured Mana Cake", sell_in: 45, quality: 33}]
    res = GildedRose.update_items(items)
    assert res == Enum.map(items, &(%{&1 | sell_in: &1.sell_in - 1, quality: &1.quality - 2}))
  end

end
