defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "two steps" do
    assert 5 == Day1.distance("R2, L3")
  end

  test "three steps" do
    assert 2 == Day1.distance("R2, R2, R2")
  end

  test "four steps" do
    assert 12 == Day1.distance("R5, L5, R5, R3")
  end

  test "manhattan math" do
    assert 0 == Day1.manhattan_distance({0, 0}, {0, 0})
    assert 1 == Day1.manhattan_distance({1, 1}, {2, 1})
    assert 1 == Day1.manhattan_distance({1, 1}, {1, 2})
    assert 1 == Day1.manhattan_distance({2, 1}, {1, 1})
    assert 1 == Day1.manhattan_distance({1, 2}, {1, 1})
    assert 5 == Day1.manhattan_distance({1, 2}, {3, -1})
  end

end
