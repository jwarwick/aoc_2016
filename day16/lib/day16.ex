defmodule Day16 do
  @moduledoc """
  Generate non-random looking random data
  """

  @doc """
  Encode a string and compute the checksum
  """
  def encode_checksum(str, length) do
    str
    |> encode(length)
    |> checksum(length)
  end

  @doc """
  Encode a string
  """
  def encode(str, min_length) do
    str
    |> String.to_charlist
    |> encode_chars_min(min_length)
    |> to_string
  end

  @doc """
  Compute checksum of a string
  """
  def checksum(str, length) do
    str
    |> String.to_charlist
    |> Enum.slice(0, length)
    |> compute_checksum
    |> to_string
  end

  defp compute_checksum(charlist) do
    charlist
    |> Enum.chunk(2)
    |> Enum.map(&checksum_chunk/1)
    |> check_done
  end

  defp check_done(charlist) do
    if 0 == rem(length(charlist), 2) do
      compute_checksum(charlist)
    else
      charlist
    end
  end

  defp checksum_chunk([a, a]), do: ?1
  defp checksum_chunk(_), do: ?0

  defp encode_chars_min(charlist, min_length) when length(charlist) < min_length do
    charlist
    |> encode_chars
    |> encode_chars_min(min_length)
  end
  defp encode_chars_min(charlist, _min), do: charlist

  defp encode_chars(charlist) do
    b = charlist
        |> Enum.reverse
        |> Enum.map(&swap_values/1)
    List.flatten([charlist, ?0, b])
  end

  defp swap_values(?0), do: ?1
  defp swap_values(?1), do: ?0
end
