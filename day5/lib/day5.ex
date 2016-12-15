defmodule Day5 do
  @moduledoc """
  Determine door passwords by generating and testing MD5 hashes for a specific pattern
  """

  @doc """
  Given a starting str, compute the password by generating hashes and testing pattern
  """
  def generate_password(str) do
    generate(str, 1, [])
  end

  defp generate(_, _, list) when length(list) == 8, do: Enum.join(list) |> String.reverse
  defp generate(str, idx, list) do
    new_list = case hash(str, idx) |> test do
      {true, val} -> [val | list]
      _ -> list
    end
    generate(str, idx+1, new_list)
  end
  
  defp test(<<"00000", x, _rest::binary>>), do: {true, <<x>>}
  defp test(_), do: false

  defp hash(str, idx) do
    input = str <> Integer.to_string(idx)
    :crypto.hash(:md5, input) |> Base.encode16(case: :lower)
  end
end
