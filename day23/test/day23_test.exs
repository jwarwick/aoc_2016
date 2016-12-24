defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  test "sample input" do
    str = """
    cpy 2 a
    tgl a
    tgl a
    tgl a
    cpy 1 a
    dec a
    dec a
    """
    result = Day23.evaluate(str)
    assert 3 == result.a
  end
end
