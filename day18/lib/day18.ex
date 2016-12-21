defmodule Day18 do
  @moduledoc """
  Figure out which tiles have traps under them
  """

  def safe_count_file(path, row_count) do
    path
    |> File.read!
    |> safe_count(row_count)
  end

  def safe_count(str, row_count) do
    str
    |> generate_rows(row_count)
    |> Enum.map(&count_safe/1)
    |> Enum.sum
  end


  defp count_safe(list) do
    list
    |> Enum.map(&convert_to_int/1)
    |> Enum.sum
  end

  defp convert_to_int(:safe), do: 1
  defp convert_to_int(:trap), do: 0
  
  def generate_rows(str, cnt) do
    charlist = convert(str)
    generate_next([charlist], cnt - 1)
  end

  defp generate_next(list, 0), do: list
  defp generate_next(list = [prev | _rest], num) do
    new = generate(prev)
    generate_next([new | list], num - 1)
  end

  @doc """
  Read an input string
  """
  def convert(str) do
    str
    |> String.trim
    |> String.to_charlist
    |> Enum.map(&convert_tile/1)
  end

  @doc """
  Generate the next row in the sequence
  """
  def generate(charlist) do
    charlist
    |> Enum.with_index
    |> Enum.map(&(generate_tile(&1, charlist)))
  end

  defp generate_tile({_val, idx}, prev_row) do
    left = get_tile(prev_row, idx - 1)
    center = get_tile(prev_row, idx)
    right = get_tile(prev_row, idx + 1)
    tile_value(left, center, right)
  end

  defp tile_value(:trap, :trap, :safe), do: :trap
  defp tile_value(:safe, :trap, :trap), do: :trap
  defp tile_value(:trap, :safe, :safe), do: :trap
  defp tile_value(:safe, :safe, :trap), do: :trap
  defp tile_value(_, _, _), do: :safe


  defp get_tile(_charlist, idx) when idx < 0, do: :safe
  defp get_tile(charlist, idx) do
    Enum.at(charlist, idx, :safe)
  end

  defp convert_tile(?.), do: :safe
  defp convert_tile(?^), do: :trap
end
