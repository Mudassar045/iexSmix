defmodule Todo.Cache do
	use GenServer

	def start do
		GenServer.start(__MODULE__, nil)
	end

	def server_process(cache_id, todo_list_key) do
		GenServer.call(cache_id, {:server_process, todo_list_key})
	end

	@impl GenServer
	def init(_) do
		{:ok, Map.new()}
	end

	@impl GenServer
	def handle_call({:server_process, todo_list_key}, _, todo_servers) do
		case Map.fetch(todo_servers, todo_list_key) do
			{:ok, todo_server} ->
				{:reply, todo_server, todo_servers}
			:error ->
			{:ok, new_server} = Todo.Server.start
			{
				:reply,
				new_server,
				Map.put(todo_servers, todo_list_key, new_server)
			}
		 end
	end

end