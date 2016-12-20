defmodule Day10 do
  @moduledoc """
  Simulate robot factory
  """

  @cmp1 61
  @cmp2 17

  def execute_file(path) do
    path
    |> File.read!
    |> execute(@cmp1, @cmp2)
  end

  @doc """
  Execute the given input commands
  """
  def execute(str, cmp1, cmp2) do
    pid_map = str
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_command/1)
    |> Enum.reduce(Map.new, &distribute_rules/2)
    |> IO.inspect
    |> Map.keys

    Enum.each(pid_map, &(distribute_cmps(&1, cmp1, cmp2)))
    Enum.each(pid_map, &(Bot.go(&1)))
  end

  defp distribute_cmps(name, cmp1, cmp2) do
    Bot.add_cmps(name, cmp1, cmp2)
  end

  defp distribute_rules(rule = {_, %{bot: b}}, map) do
    map = enusure_process_spawned(b, map)
    Bot.add_rule(b, rule)
    map
  end

  defp enusure_process_spawned(name, map) do
    if Map.has_key?(map, name) do
      map
    else
      {:ok, pid} = Bot.start_link(name)
      Map.put(map, name, pid)
    end
  end

  defp parse_command(<<"value ", rest :: binary>>) do
    splits = String.split(rest)
    value = Enum.at(splits, 0)
    bot = Enum.at(splits, -1)
    {:value, %{bot: String.to_atom(bot), value: String.to_integer(value)}}
  end
  defp parse_command(<<"bot ", rest :: binary>>) do
    splits = String.split(rest)
    bot = Enum.at(splits, 0)
    low = destination(Enum.at(splits, 4), Enum.at(splits, 5))
    high = destination(Enum.at(splits, 9), Enum.at(splits, 10))
    {:bot, %{bot: String.to_atom(bot), low: low, high: high}}
  end

  defp destination("output", num) do
    {:output, num}
  end
  defp destination("bot", num) do
    {:bot, String.to_atom(num)}
  end
end
