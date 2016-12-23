defmodule Day21 do
  @moduledoc """
  Scrambling functions
  """

  def encode_file(str, path) do
    encode(str, File.read!(path))
  end


  @doc """
  Scramble a given input following the specified commands
  """
  def encode(str, cmds) do
    cmds
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert_cmds/1)
    |> Enum.reduce(String.to_charlist(str), &execute_wrapper/2)
    |> to_string
  end

  defp convert_cmds(<<"swap position ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_integer
    y = Enum.at(list, -1) |> String.to_integer
    {:swap_position, x, y}
  end
  defp convert_cmds(<<"swap letter ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_charlist |> List.first
    y = Enum.at(list, -1) |> String.to_charlist |> List.first
    {:swap_letter, x, y}
  end
  defp convert_cmds(<<"rotate left ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_integer
    {:rotate_left, x}
  end
  defp convert_cmds(<<"rotate right ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_integer
    {:rotate_right, x}
  end
  defp convert_cmds(<<"rotate based on position of letter ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_charlist |> List.first
    {:rotate_letter, x}
  end
  defp convert_cmds(<<"reverse positions ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_integer
    y = Enum.at(list, -1) |> String.to_integer
    {:reverse_positions, x, y}
  end
  defp convert_cmds(<<"move position ", rest :: binary>>) do
    list = String.split(rest)
    x = Enum.at(list, 0) |> String.to_integer
    y = Enum.at(list, -1) |> String.to_integer
    {:move_position, x, y}
  end

  defp execute_wrapper(cmd, str) do
    IO.puts "#{inspect str}  -> #{inspect cmd}"
    result = execute(cmd, str)
    IO.puts "#{inspect result}"
    result
  end

  defp execute({:swap_position, x, y}, str) do
    swap_index(str, x, y)
  end
  defp execute({:swap_letter, x, y}, str) do
    x_idx = Enum.find_index(str, &(&1 == x))
    y_idx = Enum.find_index(str, &(&1 == y))
    swap_index(str, x_idx, y_idx)
  end
  defp execute({:reverse_positions, x, y}, str) do
    Enum.reverse_slice(str, x, (y-x)+1)
  end
  defp execute({:rotate_left, x}, str) do
    rotate_left(str, x)
  end
  defp execute({:rotate_right, x}, str) do
    rotate_right(str, x)
  end
  defp execute({:move_position, x, y}, str) do
    {v, list} = List.pop_at(str, x)
    List.insert_at(list, y, v)
  end
  defp execute({:rotate_letter, x}, str) do
    x_idx = Enum.find_index(str, &(&1 == x))
    rots = if x_idx >= 4 do
      x_idx + 1 + 1
    else
      x_idx + 1
    end
    rotate_right(str, rots)
  end

  defp rotate_left(str, 0), do: str
  defp rotate_left([v | rest], cnt) do
    rotate_left(rest ++ [v], cnt-1)
  end

  defp rotate_right(str, 0), do: str
  defp rotate_right(str, cnt) do
    {v, list} = List.pop_at(str, -1)
    rotate_right([v | list], cnt-1)
  end

  defp swap_index(str, x, y) do
    a = Enum.at(str, x)
    b = Enum.at(str, y)
    str
    |> List.replace_at(x, b)
    |> List.replace_at(y, a)
  end
end
