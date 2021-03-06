defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "1 valid" do
    assert 1 == Day3.valid_count("3 4 5")
  end

  test "0 valid" do
    assert 0 == Day3.valid_count("5 10 25")
  end

  test "multi lines" do
    str = """
    3 4 5
    5 10 25
    """
    assert 1 == Day3.valid_count(str)
  end

  test "transpose columns" do
    str = """
    3 3 3
    4 4 4
    5 5 5
    5 5 5
    10 10 10
    25 25 25
    """
    assert 3 == Day3.valid_transpose_count(str)
  end
end
