defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "no markers" do
    assert 6 == Day9.decompress("ADVENT")
  end

  test "1 marker" do
    assert 9 == Day9.decompress("(3x3)XYZ")
  end

  test "double marker" do
    assert 20 == Day9.decompress("X(8x2)(3x3)ABCY")
  end

  test "long" do
    assert 241920 == Day9.decompress("(27x12)(20x12)(13x14)(7x10)(1x12)A")
  end

  test "sample" do
    assert 445 == Day9.decompress("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
  end
end
