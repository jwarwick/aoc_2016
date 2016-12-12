defmodule Day2 do
  @moduledoc """
  Decode the bathroom lock code.

  Given a string of commands, figure out the number to enter
  """

  @doc """
  Decode a file
  """
  def decode_file(path) do
    path
    |> File.read!
    |> decode
  end

  @doc """
  Given a string of up, down, left, right commands, return the number (as a string to return)
  A digit is generated for each line of text. Assume we start at '5' in the middle of the keypad.
  """
  def decode(str) do
    str
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.reduce(%{idx: 5, result: []}, &decode_entry/2)
    |> extract_result
    |> Enum.reverse
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join
  end

  # The lookup table for the keypad
  @keypad %{
    1 => %{?U => 1, ?L => 1, ?D => 4, ?R => 2},
    2 => %{?U => 2, ?L => 1, ?D => 5, ?R => 3},
    3 => %{?U => 3, ?L => 2, ?D => 6, ?R => 3},

    4 => %{?U => 1, ?L => 4, ?D => 7, ?R => 5}, 
    5 => %{?U => 2, ?L => 4, ?D => 8, ?R => 6},
    6 => %{?U => 3, ?L => 5, ?D => 9, ?R => 6},

    7 => %{?U => 4, ?L => 7, ?D => 7, ?R => 8},
    8 => %{?U => 5, ?L => 7, ?D => 8, ?R => 9},
    9 => %{?U => 6, ?L => 8, ?D => 9, ?R => 9}
  }

  defp extract_result(%{result: result}), do: result

  defp decode_entry(entry, %{idx: idx, result: result}) do
    next_idx = _decode(idx, entry)
    %{idx: next_idx, result: [next_idx | result]}
  end

  defp _decode(idx, <<>>), do: idx
  defp _decode(idx, <<dir, rest::binary>>) do
    next_step(idx, dir)
    |> _decode(rest)
  end

  defp next_step(idx, dir) do
    @keypad[idx][dir]
  end
end
