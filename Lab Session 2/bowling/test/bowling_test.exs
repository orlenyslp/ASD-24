defmodule BowlingTest do
  use ExUnit.Case

  test "gutter game" do
    game = List.duplicate([0, 0], 9) ++ [[0, 0, nil]]
    assert Bowling.score(game) == 0
  end

  test "'all ones' game" do
    game = List.duplicate([1, 1], 9) ++ [[1, 1, nil]]
    assert Bowling.score(game) == 20
  end

  test "one spare" do
    game = [[5,5],[3,0]] ++ List.duplicate([0, 0], 7) ++ [[0, 0, nil]]
    assert Bowling.score(game) == 16
  end

  test "one spare last frame" do
    game = [[0,0],[3,0]] ++ List.duplicate([0, 0], 7) ++ [[5, 5, 3]]
    assert Bowling.score(game) == 16
  end

  test "one strike" do
    game = [[10,nil],[3,4]] ++ List.duplicate([0, 0], 7) ++ [[0, 0, nil]]
    assert Bowling.score(game) == 24
  end

  test "perfect game" do
    game = List.duplicate([10,nil], 9) ++ [[10,10,10]]
    assert Bowling.score(game) == 300
  end

  # Extra Tests

  test "one strike followed by one spare" do
    game = [[2, 3], [10, nil], [5, 5], [3, 2]] ++ List.duplicate([0,0], 5) ++ [[0, 0, nil]]
    assert Bowling.score(game) == 43
  end

  test "strike in 9th and spare 10th frames" do
    game =  List.duplicate([0, 0], 8) ++ [[10, nil], [0, 10, 3]]
    assert Bowling.score(game) == 33
  end

  test "spare in 10th frame" do
    game =  List.duplicate([0, 0], 9) ++ [[5, 5, 3]]
    assert Bowling.score(game) == 13
  end

  test "normal score only in the last frame" do
    game =  List.duplicate([0, 0], 9) ++ [[1, 5, nil]]
    assert Bowling.score(game) == 6
  end

end
