defmodule Day23 do
  @moduledoc """
  Assembunny code interpreter, with `tgl` command
  """

  defmodule State do
    defstruct pc: 0, a: 0, b: 0, c: 1, d: 0, instructions: []
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
    cmds = parse_commands(str)
    run(%State{state | instructions: cmds})
  end

  defp run(state = %State{pc: pc, instructions: instructions}) do
    instruction = Enum.at(instructions, pc)
    # IO.puts "Eval: #{inspect instruction}"
    # IO.puts "State: #{inspect state}"
    new_state = eval(instruction, state)
    # IO.inspect new_state
    unless new_state.pc >= length(instructions) do
      run(new_state)
    else
      new_state
    end
  end

  defp eval({:cpy, value, target}, state) when is_atom(value) and is_atom(target) do
    state
    |> Map.put(target, Map.get(state, value))
    |> update_pc(1)
  end
  defp eval({:cpy, value, target}, state) when is_integer(value) and is_atom(target) do
    state
    |> Map.put(target, value)
    |> update_pc(1)
  end
  defp eval({:cpy, _, _}, state) do
    update_pc(state, 1)
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
  defp eval({:jnz, test, offset}, state) when is_atom(test) and is_integer(offset) do
    val = Map.get(state, test)
    if 0 == val do
      update_pc(state, 1)
    else
      update_pc(state, offset)
    end
  end
  defp eval({:jnz, test, offset}, state) when is_integer(test) and is_integer(offset) do
    if 0 == test do
      update_pc(state, 1)
    else
      update_pc(state, offset)
    end
  end
  defp eval({:jnz, test, offset}, state) when is_integer(test) and is_atom(offset) do
    if 0 == test do
      update_pc(state, 1)
    else
      val = Map.get(state, offset)
      update_pc(state, val)
    end
  end
  defp eval({:jnz, test, offset}, state) when is_integer(test) and is_atom(offset) do
    val = Map.get(state, test)
    if 0 == val do
      update_pc(state, 1)
    else
      offset_val = Map.get(state, offset)
      update_pc(state, offset_val)
    end
  end
  defp eval({:jnz, _, _}, state) do
    update_pc(state, 1)
  end
  defp eval({:tgl, target}, state = %State{pc: pc}) do
    val = Map.get(state, target)
    idx = val + pc
    new_state = toggle_instruction(idx, state)
    update_pc(new_state, 1)
  end

  defp toggle_state_instruction(inst, idx, state = %State{instructions: instructions}) do
    new_inst = toggle_instruction(inst)
    new_instructions = List.replace_at(instructions, idx, new_inst)
    %State{state | instructions: new_instructions}
  end

  defp toggle_instruction(idx, state = %State{instructions: instructions}) do
    case Enum.at(instructions, idx, nil) do
      nil -> state
      inst -> toggle_state_instruction(inst, idx, state)
    end
  end

  defp toggle_instruction({:inc, target}), do: {:dec, target}
  defp toggle_instruction({_, target}), do: {:inc, target}
  defp toggle_instruction({:jnz, test, offset}), do: {:cpy, test, offset}
  defp toggle_instruction({_, test, offset}), do: {:jnz, test, offset}

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
  defp convert_command(<<"tgl ", rest :: binary>>) do
    {:tgl, string_to_register(rest)}
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
