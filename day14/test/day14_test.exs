defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "sample input" do
    assert 22551 == Day14.find_index(64, "abc")
  end
end
