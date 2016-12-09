defmodule Day1 do
  @moduledoc """
  Compute the Manhattan distance between two points given a path.
  """

  @doc """
  Compute manhattan distance of steps specified in a file"
  """
  def distance_file(file_path), do: distance(File.read!(file_path))

  @doc """
  Given a string of steps, compute the manhattan distance between start and end
  """
  def distance(path) do
    start_point = {0, 0}
    steps = parse_path(path)
    visited = MapSet.new |> MapSet.put(start_point)
    {_heading, end_point, duplicate_point, _visited} = Enum.reduce(steps, {:north, start_point, nil, visited}, &take_step/2)
    {manhattan_distance(start_point, end_point), manhattan_distance(start_point, duplicate_point)}
  end

  @doc """
  Compute the manhattan distance between two points
  """
  def manhattan_distance(_point, nil), do: nil
  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp parse_path(str) do
    str
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert_step/1)
    |> List.flatten
  end

  defp convert_step(<<dir, size :: binary>>) do
    steps = String.to_integer(size)
    [direction(dir), List.duplicate(:straight, steps)]
  end

  defp direction(?R), do: :right
  defp direction(?L), do: :left

  defp take_step(:right, {heading, curr, dup, visited}), do: {turn_right(heading), curr, dup, visited}
  defp take_step(:left, {heading, curr, dup, visited}), do: {turn_left(heading), curr, dup, visited}
  defp take_step(:straight, {heading, curr, dup, visited}) do
    pos = update_position(heading, curr)
    {new_dup, new_visited} = update_visited(pos, dup, visited)
    {heading, pos, new_dup, new_visited}
  end

  defp update_position(:north, {x, y}), do: {x, y+1}
  defp update_position(:east, {x, y}), do: {x+1, y}
  defp update_position(:south, {x, y}), do: {x, y-1}
  defp update_position(:west, {x, y}), do: {x-1, y}

  defp turn_right(:north), do: :east
  defp turn_right(:east), do: :south
  defp turn_right(:south), do: :west
  defp turn_right(:west), do: :north

  defp turn_left(:north), do: :west
  defp turn_left(:west), do: :south
  defp turn_left(:south), do: :east
  defp turn_left(:east), do: :north

  defp update_visited(point, dup, visited) do
    new_dup = 
      case dup do
        nil -> if MapSet.member?(visited, point), do: point, else: nil
        x -> x
      end
    {new_dup, MapSet.put(visited, point)}
  end
end
