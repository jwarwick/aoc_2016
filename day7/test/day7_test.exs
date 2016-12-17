defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "simple" do
    str = "abbac[mnopz]qrstu"
    assert true == Day7.supports_abba?(str)
    assert 1 == Day7.supports_abba_count([str])
  end

  test "in hypernet" do
    assert false == Day7.supports_abba?("abcd[bddb]xyyx")
  end

  test "duplicated chars" do
    assert false == Day7.supports_abba?("aaaa[qwer]tyui")
  end

  test "in longer string" do
    assert true == Day7.supports_abba?("ioxxoj[asdfgh]zxcvbn")
  end
end
