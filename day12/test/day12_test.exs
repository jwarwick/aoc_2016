defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "sample input" do
    str = """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """
    registers = Day12.evaluate(str)
    assert 42 == registers.a
  end
end
