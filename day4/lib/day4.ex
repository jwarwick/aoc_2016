defmodule Day4 do
  @moduledoc """
  Security through obscurity. Decode room names against a checksum.
  """

  def decode_file(input) do
    input
    |> File.read!
    |> String.trim
    |> String.split("\n")
    |> decode_list
  end

  @doc """
  Return the sum of sector numbers for valid sectors
  """
  def decode_list(list) do
    list
    |> Enum.map(&decode/1)
    |> Enum.reduce(0, &valid_sector_numbers/2)
  end

  defp valid_sector_numbers(%{checksum: checksum, computed_checksum: computed, sector: sector}, acc) do
    if checksum == computed do
      acc + sector
    else
      acc
    end
  end

  @doc """
  Given a room name, verify if it is valid
  """
  def decode(str) do
    str
    |> String.reverse
    |> String.split("-", parts: 2)
    |> Enum.map(&String.reverse/1)
    |> split_sector_checksum
    |> clean_name
    |> compute_checksum
  end

  defp split_sector_checksum([sector, name]) do
    [new_sector, checksum] = String.split(sector, "[")
    new_checksum = String.replace(checksum, "]", "")
    %{sector: String.to_integer(new_sector), checksum: new_checksum, name: name}
  end

  defp clean_name(input = %{name: name}) do
    new_name = String.replace(name, "-", "")
    %{input | name: new_name}
  end

  defp compute_checksum(input = %{name: name}) do
    sorted = String.codepoints(name) |> Enum.sort
    new_checksum = Enum.reduce(tl(sorted), [{hd(sorted), 1}], &accum/2)
    |> Enum.sort(&sort_values/2)
    |> Enum.take(5)
    |> Enum.map(fn {val, _} -> val end)
    |> Enum.join
    Map.put(input, :computed_checksum, new_checksum)
  end

  defp accum(val, [{val, cnt} | tail]), do: [{val, cnt + 1} | tail]
  defp accum(val, acc = [{_diff_val, _cnt} | _tall]), do: [{val, 1} | acc]

  defp sort_values({k1, v1}, {k2, v1}), do: k1 < k2
  defp sort_values({_k1, v1}, {_k2, v2}), do: v1 > v2

end
