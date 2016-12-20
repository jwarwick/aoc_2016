defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "sample input" do
    str = """
    value 5 goes to bot 2
    bot 2 give low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 give low to output 2 and high to output 0
    value 2 goes to bot 2
    """
    assert 2 == Day10.execute(str, 2, 5)
  end
end
