defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "empty string" do
    assert "5" == Day2.decode("")
  end

  test "one step" do
    assert "2" == Day2.decode("U")
  end

  test "stop at edge" do
    assert "4" == Day2.decode("LL")
  end

  test "longer string" do
    assert "9" == Day2.decode("UULLDDDDDDDDDDRRUDDDRRR")
  end

  test "two lines" do
    str = """
    UL
    DRDR
    """
    assert "19" == Day2.decode(str)
  end

  test "sample input" do
    str = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """
    assert "1985" == Day2.decode(str)
  end
end
