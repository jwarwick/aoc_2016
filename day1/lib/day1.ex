defmodule Day1 do
  @moduledoc """
  Compute the Manhattan distance between two points given a path.
  """

  @doc """
  Compute manhattan distance of steps specificed in a file"
  """
  def distance_file(file_path), do: distance(File.read!(file_path))

  @doc """
  Given a string of steps, compute the manhattan distance between start and end
  """
  def distance(path) do
    start_point = {0, 0}
    steps = parse_path(path)
    {_heading, end_point} = Enum.reduce(steps, {:north, start_point}, &take_step/2)
    manhattan_distance(start_point, end_point)
  end

  @doc """
  Compute the manhattan distance between two points
  """
  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp parse_path(str) do
    str
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert_step/1)
  end

  defp convert_step(<<?R, size :: binary>>) do
    {:right, String.to_integer(size)}
  end
  defp convert_step(<<?L, size :: binary>>) do
    {:left, String.to_integer(size)}
  end

  defp take_step({:right, size}, {:north, {x, y}}), do: {:east, {x + size, y}}
  defp take_step({:right, size}, {:east, {x, y}}), do: {:south, {x, y - size}}
  defp take_step({:right, size}, {:south, {x, y}}), do: {:west, {x - size, y}}
  defp take_step({:right, size}, {:west, {x, y}}), do: {:north, {x, y + size}}
  defp take_step({:left, size}, {:north, {x, y}}), do: {:west, {x - size, y}}
  defp take_step({:left, size}, {:west, {x, y}}), do: {:south, {x, y - size}}
  defp take_step({:left, size}, {:south, {x, y}}), do: {:east, {x + size, y}}
  defp take_step({:left, size}, {:east, {x, y}}), do: {:north, {x, y + size}}

end
