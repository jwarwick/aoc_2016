defmodule Day7 do
  @moduledoc """
  Determine if given addresses support ABBA
  """

  def supports_ssl_count_file(path) do
    path
    |> File.read!
    |> String.split("\n")
    |> supports_ssl_count
  end

  @doc """
  Given a list of strings, determine how many support SSL
  """
  def supports_ssl_count(list) do
   list
   |> Enum.map(&supports_ssl?/1)
   |> Enum.filter(&(&1))
   |> Enum.count(&(&1))
  end

  def supports_ssl?(str) do
    bab_supernet = 
      Regex.split(~r/\[.*]/U, str)
      |> generate_abas
      |> Enum.map(&rotate_aba/1)

    bab_hypernet =
      Regex.scan(~r/\[(.*)]/U, str, capture: :all_but_first)
      |> List.flatten
      |> expand_sequences
      |> Enum.reduce([], fn (x, acc) -> x ++ acc end)

    Enum.any?(bab_hypernet, &(check_sequences(&1, bab_supernet)))
  end

  defp check_sequences(seq, list) do
    Enum.member?(list, seq)
  end

  defp rotate_aba([a, b, a]), do: [b, a, b]

  defp generate_abas(list) do
    list
    |> expand_sequences
    |> Enum.reduce([], fn (x, acc) -> x ++ acc end)
    |> Enum.map(&contains_aba/1)
    |> Enum.filter(&(&1 != false))
  end

  defp contains_aba(x = [a, b, a]) when a != b, do: x
  defp contains_aba(_), do: false

  defp expand_sequences(list) do
    list
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&(expand_sequence(&1, 0, length(&1) - 3, [])))
  end

  defp expand_sequence(_seq, index, max, acc) when index > max, do: acc
  defp expand_sequence(seq, index, max, acc) do
    expand_sequence(seq, index + 1, max, [Enum.slice(seq, index, 3) | acc])
  end
end
