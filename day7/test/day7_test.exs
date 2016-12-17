defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "simple" do
    str = "aba[bab]xyz"
    assert true == Day7.supports_ssl?(str)
    assert 1 == Day7.supports_ssl_count([str])
  end

  test "no BAB" do
    assert false == Day7.supports_ssl?("xyx[xyx]xyx")
  end

  test "reversed order" do
    assert true == Day7.supports_ssl?("aaa[kek]eke")
  end

  test "in longer string" do
    assert true == Day7.supports_ssl?("zazbz[bzb]cdb")
  end
end
