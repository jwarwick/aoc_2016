defmodule Day2 do
  @moduledoc """
  Decode the bathroom lock code.

  Given a string of commands, figure out the number to enter
  """

  # The lookup table for the keypad in part 1
  @keypad1 %{
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

  # The lookup table for the keypad in part 2
  @keypad2 %{
    1 => %{?U => 1, ?L => 1, ?D => 3, ?R => 1},
    2 => %{?U => 2, ?L => 2, ?D => 6, ?R => 3},
    3 => %{?U => 1, ?L => 2, ?D => 7, ?R => 4},

    4 => %{?U => 4, ?L => 3, ?D => 8, ?R => 4}, 
    5 => %{?U => 5, ?L => 5, ?D => 5, ?R => 6},
    6 => %{?U => 2, ?L => 5, ?D => ?A, ?R => 7},

    7 => %{?U => 3, ?L => 6, ?D => ?B, ?R => 8},
    8 => %{?U => 4, ?L => 7, ?D => ?C, ?R => 9},
    9 => %{?U => 9, ?L => 8, ?D => 9, ?R => 9},

    ?A => %{?U => 6, ?L => ?A, ?D => ?A, ?R => ?B},
    ?B => %{?U => 7, ?L => ?A, ?D => ?D, ?R => ?C},
    ?C => %{?U => 8, ?L => ?B, ?D => ?C, ?R => ?C},
    ?D => %{?U => ?B, ?L => ?D, ?D => ?D, ?R => ?D}
  }

  @doc """
  Decode a file
  """
  def decode_file_part1(path) do
    path
    |> File.read!
    |> decode_part_1
  end

  def decode_file_part2(path) do
    path
    |> File.read!
    |> decode_part_2
  end

  @doc """
  Given a string of up, down, left, right commands, return the number (as a string to return)
  A digit is generated for each line of text. Assume we start at '5' in the middle of the keypad.
  """
  def decode_part_1(str), do: decode(str, @keypad1)

  def decode_part_2(str), do: decode(str, @keypad2)

  defp decode(str, keypad) do
    str
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.reduce(%{idx: 5, result: [], keypad: keypad}, &decode_entry/2)
    |> extract_result
    |> Enum.reverse
    |> Enum.map(&convert_to_string/1)
    |> Enum.join
  end

  defp extract_result(%{result: result}), do: result

  defp convert_to_string(x) when x <= 9, do: Integer.to_string(x)
  defp convert_to_string(x), do: <<x>>

  defp decode_entry(entry, %{idx: idx, result: result, keypad: keypad}) do
    next_idx = _decode(idx, keypad, entry)
    %{idx: next_idx, result: [next_idx | result], keypad: keypad}
  end

  defp _decode(idx, _keypad, <<>>), do: idx
  defp _decode(idx, keypad, <<dir, rest::binary>>) do
    next_step(idx, dir, keypad)
    |> _decode(keypad, rest)
  end

  defp next_step(idx, dir, keypad) do
    keypad[idx][dir]
  end
end
