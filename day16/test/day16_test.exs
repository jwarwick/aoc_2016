defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "encoding" do
    assert "100" == Day16.encode("1", 2)
    assert "001" == Day16.encode("0", 2)
    assert "11111000000" == Day16.encode("11111", 6)
    assert "1111000010100101011110000" == Day16.encode("111100001010", 13)
  end

  test "checksum" do
    assert "100" == Day16.checksum("11001011010011100", 12)
    assert "100" == Day16.checksum("110010110100", 12)
  end

  test "sample encode, checksum" do
    str = "10000"
    len = 20
    assert "01100" == Day16.encode_checksum(str, len)
  end
end
