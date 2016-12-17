defmodule Day7 do
  @moduledoc """
  Determine if given addresses support ABBA
  """

  def supports_abba_count_file(path) do
    path
    |> File.read!
    |> String.split("\n")
    |> supports_abba_count
  end

  @doc """
  Given a list of strings, determine how many support ABBA
  """
  def supports_abba_count(list) do
   list
   |> Enum.map(&supports_abba?/1)
   |> Enum.filter(&(&1))
   |> Enum.count(&(&1))
  end

  def supports_abba?(str) do
    abba_hypernet = Regex.scan(~r/\[(.*)]/U, str, capture: :all_but_first)
                    |> List.flatten
                    |> test_strings
    abba_non_hypernet = Regex.split(~r/\[.*]/U, str) |> test_strings
    !abba_hypernet && abba_non_hypernet
  end

  defp test_strings(list) do
    list
    |> expand_sequences
    |> Enum.map(&(Enum.map(&1, fn x -> contains_abba(x) end)))
    |> List.flatten
    |> Enum.any?
  end

  defp contains_abba([a, b, b, a]) when a != b, do: true
  defp contains_abba(_), do: false

  defp expand_sequences(list) do
    list
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&(expand_sequence(&1, 0, length(&1) - 4, [])))
  end

  defp expand_sequence(_seq, index, max, acc) when index > max, do: acc
  defp expand_sequence(seq, index, max, acc) do
    expand_sequence(seq, index + 1, max, [Enum.slice(seq, index, 4) | acc])
  end
end
