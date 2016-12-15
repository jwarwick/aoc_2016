defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "one entry" do
    assert "eedadn" == Day6.decode(["eedadn"])
  end

  test "three entries" do
    assert "bbbbbb" == Day6.decode(["eedadn", "bbbbbb", "eedadn"])
  end

  test "example" do
    list = ~w(
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    )
    assert "advent" == Day6.decode(list)
  end
end
