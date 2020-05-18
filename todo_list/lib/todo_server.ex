defmodule TodoServer do

	use GenServer

	#interface methods
	def start do
			GenServer.start(TodoServer, nil)
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
	def init(_) do
		{:ok, ServerTodoList.new()}
	end

	@impl GenServer
	def handle_cast({:add_entry, new_entry}, todo_list) do
		new_state = ServerTodoList.add_entry(todo_list, new_entry)
		{:noreply, new_state}
	end

	@impl GenServer
	def handle_cast({:update_entry, entry_id, new_entry}, todo_list) do
		new_state = ServerTodoList.update_entry(todo_list, entry_id, new_entry)
		{:noreply, new_state}
	end

	@impl GenServer
	def handle_cast({:delete_entry, entry_id}, todo_list) do
		new_state = ServerTodoList.delete_entry(todo_list, entry_id)
		{:noreply, new_state}
	end

	@impl GenServer
	def handle_call({:entries, date}, _, todo_list) do
		{
			:reply,
			ServerTodoList.entries(todo_list, date),
			todo_list
		}
	end

end

defmodule ServerTodoList do

	defstruct auto_id: 1, entries: Map.new()

	# Creates a new instance
	def new(entries \\ []) do
		Enum.reduce(
			entries,
			%ServerTodoList{},
			&add_entry(&2, &1)
		)
	end

	def add_entry(%ServerTodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
		# Sets the new entry's ID
		entry = Map.put(entry, :id, auto_id)

		# Add new entry in the entries list
		new_entries = Map.put(entries, auto_id, entry)

		# update the struct
		%ServerTodoList{todo_list | entries: new_entries, auto_id: auto_id + 1}
	end

	def entries(%ServerTodoList{entries: entries}, date) do
		entries
		# Filters entries for a given date
		|> Stream.filter(fn {_, entry} ->
			entry.date == date
		end)
		# Takes only values
		|> Enum.map(fn {_, entry} ->
			entry
		end)
	end

	def update_entry(
				%ServerTodoList{entries: entries} = todo_list,
				entry_id,
				updater_fun
			) do
		case entries[entry_id] do
			nil ->
				todo_list

			old_entry ->
				# to make sure it must return a map
				new_entry = %{} = updater_fun.(old_entry)
				# new_entry = %{id: ^old_entry_id} = updater_fun(old_entry)
				new_entries = Map.put(entries, new_entry.id, new_entry)

				%ServerTodoList{todo_list | entries: new_entries}
		end
	end

	def update_entry(todo_list, %{} = new_entry) do
		update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
	end

	def delete_entry(
				%ServerTodoList{entries: entries} = todo_list,
				entry_id
		) do
		case entries[entry_id] do
			nil ->
				todo_list

			old_entry ->
				# Add new entry in the entries list
				new_entries =
					entries
					# Filters entries against deletable entry
					|> Enum.filter(fn {_, entry} ->
						entry.id != old_entry.id
					end)

				# update the struct
				%ServerTodoList{todo_list | entries: new_entries}
		end
	end

	# def delete_entry(todo_list, entry_id) do
	# 	%ServerTodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
	# end

end