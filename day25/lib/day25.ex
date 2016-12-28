defmodule Day25 do
  @moduledoc """
  Assembunny code interpreter, with output command
  """

  @clk_count_enough 10000

  defmodule State do
    defstruct pc: 0, a: 0, init_a: 0, b: 0, c: 1, d: 0, clk_last: 1, clk_count: 0, clk_error: false
  end

  def evaluate_file(path, state \\ %State{}) do
    path
    |> File.read!
    |> evaluate(state)
  end

  @doc """
  Evaluate the given instruction set
  """
  def evaluate(str, state \\ %State{}) do
    str
    |> parse_commands
    |> search(state)
  end

  defp search(instructions, %State{a: a}) do
    new_state = %State{a: a, init_a: a}
    # IO.puts "Testing a = #{inspect a}"
    result = run(instructions, new_state)
    if !result.clk_error do
      result.init_a
    else
      search(instructions, %State{new_state | a: new_state.init_a + 1})
    end
  end

  defp run(instructions, state = %State{pc: pc}) do
    instruction = Enum.at(instructions, pc)
    # IO.puts "Eval: #{inspect instruction}"
    new_state = eval(instruction, state)
    # IO.inspect new_state
    unless new_state.pc >= length(instructions) do
      run(instructions, new_state)
    else
      new_state
    end
  end

  defp eval({:cpy, value, target}, state) when is_atom(value) do
    state
    |> Map.put(target, Map.get(state, value))
    |> update_pc(1)
  end
  defp eval({:cpy, value, target}, state) when is_integer(value) do
    state
    |> Map.put(target, value)
    |> update_pc(1)
  end
  defp eval({:inc, target}, state) do
    state
    |> Map.update!(target, &(&1 + 1))
    |> update_pc(1)
  end
  defp eval({:dec, target}, state) do
    state
    |> Map.update!(target, &(&1 - 1))
    |> update_pc(1)
  end
  defp eval({:jnz, test, offset}, state) when is_atom(test) do
    val = Map.get(state, test)
    if 0 == val do
      update_pc(state, 1)
    else
      update_pc(state, offset)
    end
  end
  defp eval({:jnz, test, offset}, state) when is_integer(test) do
    if 0 == test do
      update_pc(state, 1)
    else
      update_pc(state, offset)
    end
  end
  defp eval({:out, target}, state) when is_atom(target) do
    val = Map.get(state, target)
    check_clk(val, state)
  end
  defp eval({:out, target}, state) when is_integer(target) do
    check_clk(target, state)
  end

  defp check_clk(a, state = %State{clk_last: a}) do
    # IO.puts "Matched, got: #{inspect a}, last: #{inspect a}, cnt: #{state.clk_count}"
    %State{state | clk_error: true, pc: 99999999}
  end
  defp check_clk(a, state = %State{clk_last: b, clk_count: cnt}) when a != b and cnt >= @clk_count_enough do
    # IO.puts "Got enough chars"
    %State{state | clk_error: false, pc: 99999999}
  end
  defp check_clk(a, state = %State{clk_last: b}) when a != b do
    # IO.puts "Ok, got: #{inspect a}, last: #{inspect b}"
    new = %State{state | clk_last: a, clk_count: state.clk_count + 1}
    update_pc(new, 1)
  end

  defp update_pc(state, offset) do
    Map.update!(state, :pc, &(&1 + offset))
  end

  defp parse_commands(str) do
    str
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert_command/1)
  end

  defp convert_command(<<"inc ", rest :: binary>>) do
    {:inc, string_to_register(rest)}
  end
  defp convert_command(<<"dec ", rest :: binary>>) do
    {:dec, string_to_register(rest)}
  end
  defp convert_command(<<"cpy ", rest :: binary>>) do
    [value, register] = String.split(rest)
    {:cpy, convert_value(value), string_to_register(register)}
  end
  defp convert_command(<<"jnz ", rest :: binary>>) do
    [test, offset] = String.split(rest)
    {:jnz, convert_value(test), convert_value(offset)}
  end
  defp convert_command(<<"out ", rest :: binary>>) do
    {:out, convert_value(rest)}
  end

  defp convert_value(str) do
    list = String.to_charlist(str)
    if Enum.at(list, 0) >= ?a do
      string_to_register(str)
    else
      String.to_integer(str)
    end
  end

  defp string_to_register(str) do
    String.to_atom(str)
  end
end
