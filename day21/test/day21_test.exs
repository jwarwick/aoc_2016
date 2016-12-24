defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  test "sample input" do
    cmds = """
    swap position 4 with position 0
    swap letter d with letter b 
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
    """
    assert "abcde" == Day21.decode("decab", cmds)
  end
end