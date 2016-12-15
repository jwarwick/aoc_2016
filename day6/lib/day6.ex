defmodule Day6 do
  @moduledoc """
  Decode repitition code of a list of strings
  """

  def decode_from_file(path) do
    path
    |> File.read!
    |> String.split("\n")
    |> decode
  end

  @doc """
  Given a list of strings, compute the string built from the character more frequently
  in each position.
  """
  def decode(list) do
    initial = List.duplicate(%{}, String.length(hd(list)))
    list
    |> Enum.reduce(initial, &count_string/2)
    |> Enum.map(&map_max/1)
    |> IO.iodata_to_binary
  end

  defp count_string(string, acc) do
    string
    |> to_charlist
    |> Enum.with_index
    |> Enum.reduce(acc, &count_char/2)
  end

  defp count_char({value, index}, acc) do
    curr_map = Enum.at(acc, index)
    updated_map = Map.update(curr_map, value, 1, &(&1 + 1))
    List.replace_at(acc, index, updated_map)
  end

  defp map_max(map) do
    map
    |> Map.to_list
    |> Enum.sort(fn ({_k1, v1}, {_k2, v2}) -> v1 >= v2 end)
    |> Enum.map(fn {key, _value} -> key end)
    |> hd
  end
end
