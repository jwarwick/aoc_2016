defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "empty string" do
    assert "5" == Day2.decode_part_1("")
  end

  test "one step" do
    assert "2" == Day2.decode_part_1("U")
  end

  test "stop at edge" do
    assert "4" == Day2.decode_part_1("LL")
  end

  test "longer string" do
    assert "9" == Day2.decode_part_1("UULLDDDDDDDDDDRRUDDDRRR")
  end

  test "two lines" do
    str = """
    UL
    DRDR
    """
    assert "19" == Day2.decode_part_1(str)
  end

  test "sample input" do
    str = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """
    assert "1985" == Day2.decode_part_1(str)
  end

  test "part 2 1 step" do
    assert "5" == Day2.decode_part_2("U")
  end

  test "sample input, part 2" do
    str = """
    ULL
    RRDDD
    LURDL
    UUUUD
    """
    assert "5DB3" == Day2.decode_part_2(str)
  end
end
