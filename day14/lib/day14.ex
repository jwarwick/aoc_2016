defmodule Day14 do
  @moduledoc """
  One time pad
  """

  defmodule State do
    defstruct curr_idx: 0, remaining: 0, salt: nil
  end

  @doc """
  Find the index for a given key
  """
  def find_index(idx, salt) do
    hash_search(%State{curr_idx: 0, remaining: idx, salt: salt})
  end

  defp hash_search(%State{curr_idx: idx, remaining: 0}), do: idx-1
  defp hash_search(state = %State{curr_idx: idx, salt: salt, remaining: remaining}) do
    result = test_hash(salt, idx)
    remaining = case result do
      true -> remaining - 1
      _ -> remaining
    end
    hash_search(%State{state | curr_idx: idx + 1, remaining: remaining})
  end

  def test_hash(salt, idx) do
    md5 = compute_hash(salt, idx)
    # IO.puts "idx: #{inspect idx}, testing: #{inspect md5}"
    case has_three?(md5) do
      {true, match} -> test_sub_hash(match |> String.at(0) |> String.duplicate(5), salt, idx + 1, 1000)
      _ -> false
    end
  end

  defp test_sub_hash(_str, _salt, _idx, 0), do: false
  defp test_sub_hash(str, salt, idx, remaining) do
    # IO.puts "Testing sub-hash: #{inspect idx}, remaining: #{inspect remaining}"
    md5 = compute_hash(salt, idx)
    # IO.inspect md5
    if String.contains?(md5, str) do
      true
    else
      test_sub_hash(str, salt, idx+1, remaining-1)
    end
  end

  defp compute_hash(salt, idx) do
    str = salt <> Integer.to_string(idx)
    :crypto.hash(:md5 , str)
    |> Base.encode16()
    |> String.downcase
  end

  @regex Regex.compile("([a-z0-9])\\1\\1")

  defp has_three?(str) do
    {:ok, reg} = @regex
    case Regex.run(reg, str) do
      nil -> {:false, nil}
      [first | _rest] -> {:true, first}
    end
  end
  
end
