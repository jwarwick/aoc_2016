defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "sample input" do
    assert "18f47a30" == Day5.generate_password("abc")
  end
end
