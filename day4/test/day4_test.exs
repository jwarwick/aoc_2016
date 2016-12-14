defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "single correct" do
    assert 123 == Day4.decode_list(["aaaaa-bbb-z-y-x-123[abxyz]"])
    assert 987 == Day4.decode_list(["a-b-c-d-e-f-g-h-987[abcde]"])
    assert 404 == Day4.decode_list(["not-a-real-room-404[oarel]"])
    assert 0 == Day4.decode_list(["totally-real-room-200[decoy]"])
  end

  test "list correct" do
    list = [
      "aaaaa-bbb-z-y-x-123[abxyz]",
      "a-b-c-d-e-f-g-h-987[abcde]",
      "not-a-real-room-404[oarel]",
      "totally-real-room-200[decoy]"
    ]

  assert (123 + 987 + 404) == Day4.decode_list(list)
  end
end
