defmodule Day5 do
  @moduledoc """
  Determine door passwords by generating and testing MD5 hashes for a specific pattern
  """

  @doc """
  Given a starting str, compute the password by generating hashes and testing pattern
  """
  def generate_password(str) do
    generate(str, 1, List.duplicate(nil, 8), 0)
  end

  defp generate(_, _, list, cnt) when cnt == 8, do: Enum.join(list)
  defp generate(str, idx, list, cnt) do
    {new_cnt, new_list} = case hash(str, idx) |> test do
      {true, index, val} -> update_list(list, index, val, cnt)
      _ -> {cnt, list}
    end
    generate(str, idx+1, new_list, new_cnt)
  end

  defp update_list(list, index, _, cnt) when index < 0 or index > 7, do: {cnt, list}
  defp update_list(list, index, value, cnt) do
    case nil == Enum.at(list, index) do
     true -> {cnt + 1, List.replace_at(list, index, value)}
     _ -> {cnt, list}
    end 
  end
  
  defp test(<<"00000", idx, value, _rest::binary>>), do: {true, String.to_integer(<<idx>>, 16), <<value>>}
  defp test(_), do: false

  defp hash(str, idx) do
    input = str <> Integer.to_string(idx)
    :crypto.hash(:md5, input) |> Base.encode16(case: :lower)
  end
end
