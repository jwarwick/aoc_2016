defmodule Day8 do
  @moduledoc """
  Two factor authentication screen emulator
  """

  @default_width 50
  @default_height 6

  def count_pixels_from_file(path), do: count_pixels_from_file(@default_height, @default_width, path)
  def count_pixels_from_file(rows, columns, path) do
    compute(rows, columns, File.read!(path))
    |> List.flatten
    |> Enum.sum
  end

  @doc """
  Display part of the board
  """
  def display(board, start_col, count) do
    board
    |> Enum.map(&(Enum.slice(&1, start_col, count)))
    |> Enum.map(&(Enum.map(&1, fn x -> if 1 == x, do: nil, else: " " end)))
    |> Enum.each(&IO.inspect/1)
    IO.puts "\n\n\n"
  end

  @doc """
  Run the given list of commands on an empty board
  """
  def compute(commands), do: compute(@default_height, @default_width, commands)
  def compute(rows, columns, commands) do
    row = List.duplicate(0, columns)
    board = List.duplicate(row, rows)
    commands = commands |> String.trim |> String.split("\n")
    execute_commands(board, commands)
  end

  def execute_commands(board, []), do: board
  def execute_commands(board, [cmd | rest]) do
    cmd = parse_cmd(cmd)
    board = execute_command(board, cmd)
    execute_commands(board, rest)
  end

  def parse_cmd("rect " <> str) do
    [cols, rows] = String.trim(str) |> String.split("x") |> Enum.map(&String.to_integer/1)
    {:rect, cols, rows}
  end
  def parse_cmd("rotate row y="<> str) do
    [row, count] = String.split(str, " by ") |> Enum.map(&String.to_integer/1)
    {:rot_row, row, count}
  end
  def parse_cmd("rotate column x=" <> str) do
    [col, count] = String.split(str, " by ") |> Enum.map(&String.to_integer/1)
    {:rot_col, col, count}
  end

  def execute_command(board, {:rect, cols, rows}) do
    IO.puts "rect: #{inspect cols}, #{inspect rows}"
    fill_rows(board, cols, rows-1)
  end
  def execute_command(board, {:rot_row, row, count}) do
    IO.puts "rotate row: #{inspect row}, #{inspect count}"
    List.update_at(board, row, &(shift_row(&1, count)))
  end
  def execute_command(board, {:rot_col, col, count}) do
    IO.puts "rotate col: #{inspect col}, #{inspect count}"
    col_vals = Enum.map(board, &(Enum.at(&1, col))) |> shift_row(count)
    zipped = List.zip([board, col_vals])
    Enum.map(zipped, &(update_col(&1, col)))
  end

  defp update_col({list, val}, col), do: List.replace_at(list, col, val)

  defp shift_row(row, cnt) when cnt <= 0, do: row
  defp shift_row(row, cnt) do
    {val, list} = List.pop_at(row, -1)
    shift_row([val | list], cnt-1)
  end

  defp fill_rows(board, _cols, idx) when idx < 0, do: board
  defp fill_rows(board, cols, idx) do
    board = List.update_at(board, idx, &(fill_row(&1, cols-1)))
    fill_rows(board, cols, idx-1)
  end

  defp fill_row(list, idx) when idx < 0, do: list
  defp fill_row(list, idx) do
    List.replace_at(list, idx, 1)
    |> fill_row(idx-1)
  end

end
