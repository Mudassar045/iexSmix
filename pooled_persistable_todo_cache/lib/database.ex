defmodule Todo.Database do
	use GenServer

	@db_folder "./persist"

	def start do
		GenServer.start(__MODULE__, nil, name: __MODULE__)
	end

	def store(key, data) do
		key
		|> choose_worker()
		|> Todo.DatabaseWorker.store(key, data)
	end

	def get(key) do
		key
		|> choose_worker()
		|> Todo.DatabaseWorker.get(key)
	end

	# Choosing a worker makes a request to the database server process. There we
  # keep the knowledge about our workers, and return the pid of the corresponding
  # worker. Once this is done, the caller process will talk to the worker directly.
  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

	@impl GenServer
	def init(db_folder) do
		File.mkdir_p!(db_folder) # make suare the folder exists
		{:ok, start_workers()}
	end

	# Get_worker should always return the same worker for the same key.
	# The easiest way to do this is to compute the key’s numerical hash and normalize it to fall in the range [0, 2].
	# This can be done by calling :erlang.phash2(key, 3).

	@impl GenServer
	def handle_call({:choose_worker, key}, _, workers) do
		worker_key = :erlang.phash2(key, 3)
		{:reply, Map.get(workers, worker_key), workers}
	end

	defp start_workers() do
    for index <- 1..3, into: %{} do
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {index - 1, pid}
    end
  end

end