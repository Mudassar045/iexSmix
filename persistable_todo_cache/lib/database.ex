defmodule Todo.Database do
	use GenServer

	def start(db_folder) do
		name: database_server
		)
	end

	def store(key, data) do
		GenServer.cast(:database_server, {:store, key, data})
	end

	def get(key) do
		GenServer.call(:database_server, {:get, key})
	end

	@impl GenServer
	def init(db_folder) do
		File.mkdir_p(db_folder) # make suare the folder exists
		{:ok, db_folder}
	end

	@impl GenServer
	def handle_cast({:store, key, data}, db_folder) do
		file_name(db_folder, key)
		|> File.write!(:erlan.term_to_binary(data))
		{:noreply, db_folder}
	end

	@impl GenServer
	def handle_call({:get, key}, db_folder) do
		data  = case file_name(db_folder, key) do
		{:ok, contents} -> :erlang.binary_to_term(data)
		_ -> nil
		end
		{:reply, data, db_folder}
	end

	defp file_name(db_folder, key), do: "#{db_folder}/#{key}"

end