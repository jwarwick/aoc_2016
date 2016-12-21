defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  test "generate" do
    str = "..^^."
    curr = Day18.convert(str)
    next = [:safe, :trap, :trap, :trap, :trap]
    result = [next] ++ [curr]
    assert result == Day18.generate_rows(str, 2)
  end

  test "count" do
    str = ".^^.^.^^^^"
    assert 38 == Day18.safe_count(str, 10)
  end
end
