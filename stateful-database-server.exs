defmodule DatabaseServer do

  def start do
    spawn(fn ->
      initial_state = :random.uniform(1000)
      loop(initial_state)
    end) # start the loop concurrently
  end

  defp loop(connection) do
    receive do
      {:run_query, from_pid, query_def} ->
      query_res  = run_query(connection, query_def)
      send(from_pid, {:query_result, query_res})
    end
    loop(connection) # keeps looping
  end

  defp run_query(connection, query_def) do
    :timer.sleep(2000)
    "#{connection}: #{query_def} result"
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self, query_def})
  end

  def get_result do
    receive do
     {:query_result, result } -> result
    after 5000 ->
     {:error, :timeout}
  end
end
