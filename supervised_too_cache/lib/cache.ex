defmodule Todo.Cache do
	use GenServer

	def start_link do

		IO.puts "start todo cache"

		GenServer.start_link(__MODULE__, nil,  name: :todo_cache)
	end

	def server_process(list_key) do
		GenServer.call(:todo_cache, {:server_process, list_key})
	end

	@impl GenServer
	def init(_) do
		Todo.Database.start()
		{:ok, Map.new()}
	end

	@impl GenServer
	def handle_call({:server_process, list_key}, _, todo_servers) do
		case Map.fetch(todo_servers, list_key) do
			{:ok, todo_server} ->
				{:reply, todo_server, todo_servers}
			:error ->
			{:ok, new_server} = Todo.Server.start(list_key)
			{
				:reply,
				new_server,
				Map.put(todo_servers, list_key, new_server)
			}
		 end
	end

end