defmodule Day9 do
  @moduledoc """
  Decompress the compression format
  """

  def decompress_file(path) do
    path
    |> File.read!
    |> String.trim
    |> decompress
    |> String.length
  end

  @doc """
  Decompress the given string
  """
  def decompress(str) do
    str
    |> String.to_charlist
    |> decode([])
    |> to_string
  end

  defp decode([], acc), do: Enum.reverse(acc)
  defp decode([?( | rest], acc) do
    {cmd, remainder} = Enum.split_while(rest, &(&1 != ?)))
    remainder = Enum.drop(remainder, 1)
    [num_chars, repeats] = 
      cmd
      |> to_string
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)
    chars = Enum.slice(remainder, 0, num_chars)
    dups = List.duplicate(chars, repeats)
    remainder = Enum.drop(remainder, num_chars)
    decode(remainder, [dups | acc])
  end
  defp decode([x | rest], acc) do
    decode(rest, [x | acc])
  end

end
