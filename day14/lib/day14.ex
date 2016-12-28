defmodule Day14 do
  @moduledoc """
  One time pad
  """

  defmodule State do
    defstruct curr_idx: 0, remaining: 0, salt: nil, cache: Map.new
  end

  @doc """
  Find the index for a given key
  """
  def find_index(idx, salt) do
    hash_search(%State{curr_idx: 0, remaining: idx, salt: salt})
  end

  defp hash_search(%State{curr_idx: idx, remaining: 0}), do: idx-1
  defp hash_search(state = %State{curr_idx: idx, salt: salt, remaining: remaining, cache: cache}) do
    {result, cache} = test_hash(salt, idx, cache)
    if result == true do
      IO.puts "Key #{inspect idx}, remaining: #{inspect remaining}"
    end
    remaining = case result do
      true -> remaining - 1
      _ -> remaining
    end
    hash_search(%State{state | curr_idx: idx + 1, remaining: remaining, cache: cache})
  end

  def test_hash(salt, idx, cache) do
    {md5, cache} = compute_hash(salt, idx, cache)
    # IO.puts "idx: #{inspect idx}, testing: #{inspect md5}"
    case has_three?(md5) do
      {true, match} -> test_sub_hash(match |> String.at(0) |> String.duplicate(5), salt, idx + 1, 1000, cache)
      _ -> {false, cache}
    end
  end

  defp test_sub_hash(_str, _salt, _idx, 0, cache), do: {false, cache}
  defp test_sub_hash(str, salt, idx, remaining, cache) do
    # IO.puts "Testing sub-hash: #{inspect idx}, remaining: #{inspect remaining}"
    {md5, cache} = compute_hash(salt, idx, cache)
    # IO.inspect md5
    if String.contains?(md5, str) do
      {true, cache}
    else
      test_sub_hash(str, salt, idx+1, remaining-1, cache)
    end
  end

  defp compute_hash(salt, idx, cache) do
   case Map.fetch(cache, idx) do
      {:ok, val} -> {val, cache}
      :error -> update_hash(cache, salt, idx)
    end
  end

  defp update_hash(hash, salt, idx) do
    val = _compute_hash(salt, idx)
    {val, Map.put(hash, idx, val)}
  end

  defp _compute_hash(salt, idx) do
    # IO.puts "Computing hash #{inspect idx}"
    salt <> Integer.to_string(idx)
    |> hash
    |> subhash(2016)
  end

  defp subhash(str, 0), do: str
  defp subhash(str, remaining) do
    subhash(hash(str), remaining - 1)
  end

  defp hash(str) do
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
