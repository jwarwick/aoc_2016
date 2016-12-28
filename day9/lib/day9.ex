defmodule Day9 do
  @moduledoc """
  Decompress the compression format
  """

  def decompress_file(path) do
    path
    |> File.read!
    |> String.trim
    |> decompress
  end

  @doc """
  Decompress the given string
  """
  def decompress(str) do
    str
    |> String.to_charlist
    |> decode()
  end

  defp decode(list), do: decode(list, 0)

  defp decode([], cnt), do: cnt
  defp decode([?( | rest], cnt) do
    {cmd, remainder} = Enum.split_while(rest, &(&1 != ?)))
    remainder = Enum.drop(remainder, 1)
    [num_chars, repeats] = 
      cmd
      |> to_string
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)
    chars = Enum.slice(remainder, 0, num_chars)
    chars_count = repeats * decode(chars)
    remainder = Enum.drop(remainder, num_chars)
    decode(remainder, cnt + chars_count)
  end
  defp decode([x | rest], cnt) do
    decode(rest, cnt + 1)
  end

end
