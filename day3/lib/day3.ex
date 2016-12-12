defmodule Day3 do
  @moduledoc """
  Compute number of valid triangles in the input
  """

  @doc """
  Compute the number of valid triangles in the given file
  """
  def valid_count_file(path) do
    path
    |> File.read!
    |> valid_count
  end

  @doc """
  Split the given string into possible triangles. Return the number of valid triangles.
  Assumes one triangle per line.
  """
  def valid_count(str) do
    str
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&convert_to_ints/1)
    |> Enum.map(&build_permutations/1)
    |> Enum.map(&compute_valid/1)
    |> Enum.map(&Enum.all?/1)
    |> Enum.count(&(&1 == true))
  end

  defp convert_to_ints(str) do
    [a, b, c] = String.split(str, " ", trim: true)
    {String.to_integer(a), String.to_integer(b), String.to_integer(c)}
  end

  defp build_permutations({a, b, c}) do
    [ {a, b, c}, {b, c, a}, {c, a, b} ]
  end

  defp compute_valid([a, b, c]) do
    [test(a), test(b), test(c)]
  end

  defp test({a, b, c}), do: a + b >= c

end
