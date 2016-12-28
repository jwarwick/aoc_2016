defmodule Day22 do
  @moduledoc """
  Shuffle data around in storage grid
  """

  defmodule Node do
    defstruct [:name, :size, :used, :avail, :percent]
  end

  def compute_viable_file(path) do
    path
    |> File.read!
    |> compute_viable
  end

  @doc """
  Count the number of viable pairs of nodes
  """
  def compute_viable(str) do
    nodes = parse_input(str)
    results = for a <- nodes, b <- nodes, a.name != b.name, do: viable?(a,b)
    Enum.count(results, &(&1))
  end

  defp viable?(%Node{used: 0}, _), do: false
  defp viable?(%Node{used: a_used}, %Node{avail: b_avail}), do: a_used <= b_avail

  defp parse_input(str) do
    str
    |> String.trim
    |> String.split("\n")
    |> Enum.drop(2)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(str) do
    [name, size, used, avail, percent] = 
      String.split(str, " ", trim: true)
    %Node{name: name, size: parse_num(size), used: parse_num(used),
      avail: parse_num(avail), percent: parse_num(percent)}
  end

  defp parse_num(str) do
    str
    |> String.replace_trailing("T", "")
    |> String.replace_trailing("%", "")
    |> String.to_integer
  end
end
