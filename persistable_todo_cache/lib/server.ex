defmodule Todo.Server do

	use GenServer

	#interface methods
	def start(list_key) do
			GenServer.start(__MODULE__, list_key)
	end

	def add_entry(todo_server, new_entry) do
		GenServer.cast(todo_server, {:add_entry, new_entry})
	end

	def update_entry(todo_server, entry_id, new_entry) do
		GenServer.cast(todo_server, {:update_entry, entry_id, new_entry})
	end

	def delete_entry(todo_server, entry_id) do
		GenServer.cast(todo_server, {:delete_entry, entry_id})
	end

	def entries(todo_server, date) do
		GenServer.call(todo_server, {:entries, date})
	end

	# overriding-callbacks
	@impl GenServer
	def init(list_key) do
		{:ok, {list_key, Todo.Database.get(list_key) || Todo.List.new()}}
	end

	@impl GenServer
	def handle_cast({:add_entry, new_entry}, {key, todo_list}) do
		new_state = Todo.List.add_entry(todo_list, new_entry)
		Todo.Database.store(key, new_state)
		{:noreply, {key, new_state}}
	end

	@impl GenServer
	def handle_cast({:update_entry, entry_id, new_entry}, {key, todo_list}) do
		new_state = Todo.List.update_entry(todo_list, entry_id, new_entry)
		Todo.Database.store(key, new_state)
		{:noreply, {key, new_state}}
	end

	@impl GenServer
	def handle_cast({:delete_entry, entry_id}, {key, todo_list}) do
		new_state = Todo.List.delete_entry(todo_list, entry_id)
		{:noreply, {key, new_state}}
	end

	@impl GenServer
	def handle_call({:entries, date}, _, {key, todo_list}) do
		{
			:reply,
			Todo.List.entries(todo_list, date),
			{key, todo_list}
		}
	end

end