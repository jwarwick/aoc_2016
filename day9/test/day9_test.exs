defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "no markers" do
    assert "ADVENT" == Day9.decompress("ADVENT")
  end

  test "1 marker" do
    assert "ABBBBBC" == Day9.decompress("A(1x5)BC")
  end

  test "start marker" do
    assert "XYZXYZXYZ" == Day9.decompress("(3x3)XYZ")
  end

  test "two markers" do
    assert "ABCBCDEFEFG" == Day9.decompress("A(2x2)BCD(2x2)EFG")
  end

  test "duplicate marker" do
    assert "(1x3)A" == Day9.decompress("(6x1)(1x3)A")
  end

  test "multiple duplicates" do
    assert "X(3x3)ABC(3x3)ABCY" == Day9.decompress("X(8x2)(3x3)ABCY")
  end
end
