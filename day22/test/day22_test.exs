defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  test "sample input" do
    str = """
    root@ebhq-gridcenter# df -h
    Filesystem              Size  Used  Avail  Use%
    /dev/grid/node-x0-y0     85T   66T    19T   77%
    /dev/grid/node-x0-y1     93T   18T    27T   70%
    /dev/grid/node-x0-y2     93T   65T    28T   69%
    /dev/grid/node-x3-y3     93T   0T    28T   69%
    """
    assert 3 == Day22.compute_viable(str)
  end
end
