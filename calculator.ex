defmodule Calculator do
  def start do
    # initial state 0
    spawn(fn -> loop(0) end)
  end

  # defp loop(curr_val) do
  #   new_val = receive do
  #     {:value, caller} ->
  #     send(caller, {:response, curr_val}})
  #     curr_val

  #     {:add, value} -> curr_val + value
  #     {:sub, value} -> curr_val - value
  #     {:mul, value} -> curr_val * value
  #     {:div, value} -> curr_val / value

  #     invalid_req ->
  #       IO.puts "Invalid request #{inspect invalid_request}"
  #   end
  #   loop(new_val)
  # end

  defp loop(curr_val) do
    new_val =
      receive do
        message ->
          process_message(curr_val, message)
      end

    loop(new_val)
  end

  def value(server_pid) do
    send(server_pid, {:value, self})

    receive do
      {:response, value} ->
        value
    end
  end

  defp process_message(curr_val, {:value, caller}) do
    send(caller, {:response, curr_val})
    curr_val
  end

  defp process_message(curr_val, {:add, value}) do
    curr_val + value
  end

  defp process_message(curr_val, {:sub, value}) do
    curr_val - value
  end

  defp process_message(curr_val, {:mul, value}) do
    curr_val * value
  end

  defp process_message(curr_val, {:div, value}) do
    curr_val / value
  end

  def add(server_pid, value), do: send(server_pid, {:add, value})
  def sub(server_pid, value), do: send(server_pid, {:sub, value})
  def mul(server_pid, value), do: send(server_pid, {:mul, value})
  def div(server_pid, value), do: send(server_pid, {:div, value})
end
