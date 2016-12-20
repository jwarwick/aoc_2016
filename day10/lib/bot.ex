defmodule Bot do
  @moduledoc """
  Implementation of a bot
  """

  use GenServer

  defstruct [:name, :value1, :value2, :low, :high, :cmp1, :cmp2]

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def add_rule(name, rule) do
    GenServer.cast(name, {:rule, rule})
  end

  def add_cmps(name, cmp1, cmp2) do
    GenServer.cast(name, {:cmps, cmp1, cmp2})
  end

  def go(name) do
    GenServer.cast(name, {:go})
  end

  def send_value({:output, name}, value) do
    IO.puts "Output #{inspect name} got value #{inspect value}"
  end
  def send_value({:bot, name}, value) do
    GenServer.cast(name, {:new_value, value})
  end

  def init(name) do
    {:ok, %Bot{name: name}}
  end

  def handle_cast({:rule, {:value, %{value: v}}}, bot = %Bot{}) do
    bot = update_values(v, bot)
    IO.inspect bot
    {:noreply, bot}
  end
  def handle_cast({:rule, {:bot, %{low: l, high: h}}}, bot = %Bot{}) do
    bot = %Bot{bot | low: l, high: h}
    IO.inspect bot
    {:noreply, bot}
  end
  def handle_cast({:cmps, cmp1, cmp2}, bot = %Bot{}) do
    bot = %Bot{bot | cmp1: cmp1, cmp2: cmp2}
    IO.inspect bot
    {:noreply, bot}
  end
  def handle_cast({:go}, bot = %Bot{}) do
    bot = take_step(bot)
    {:noreply, bot}
  end
  def handle_cast({:new_value, value}, bot) do
    # IO.puts "#{inspect bot.name} got value #{inspect value}"
    bot = update_values(value, bot)
    bot = take_step(bot)
    {:noreply, bot}
  end

  defp update_values(v, bot) do
    case bot.value1 do
      nil -> %Bot{bot | value1: v}
      _ -> %Bot{bot | value2: v}
    end
  end

  defp take_step(bot) do
    if bot.value1 && bot.value2 do
      distribute_values(bot)
    else
      bot
    end
  end

  defp distribute_values(bot = %Bot{}) do
    values = [bot.value1, bot.value2] |> Enum.sort
    cmps = [bot.cmp1, bot.cmp2] |> Enum.sort
    test_cmps(bot, values, cmps)
    # IO.puts "#{inspect bot.name} sending values"
    Bot.send_value(bot.low, Enum.at(values, 0))
    Bot.send_value(bot.high, Enum.at(values, 1))
    %Bot{bot | value1: nil, value2: nil}
  end

  defp test_cmps(bot, a, a) do
    IO.puts "\n\nGOT MATCH, bot = #{inspect bot.name}\n\n"
    true
  end
  defp test_cmps(_, _, _), do: false

end
