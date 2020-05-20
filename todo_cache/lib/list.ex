defmodule Todo.List do

	defstruct auto_id: 1, entries: Map.new()

	# Creates a new instance
	def new(entries \\ []) do
		Enum.reduce(
			entries,
			%__MODULE__{},
			&add_entry(&2, &1)
		)
	end

	def add_entry(%__MODULE__{entries: entries, auto_id: auto_id} = todo_list, entry) do
		# Sets the new entry's ID
		entry = Map.put(entry, :id, auto_id)

		# Add new entry in the entries list
		new_entries = Map.put(entries, auto_id, entry)

		# update the struct
		%__MODULE__{todo_list | entries: new_entries, auto_id: auto_id + 1}
	end

	def entries(%__MODULE__{entries: entries}, date) do
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
				%__MODULE__{entries: entries} = todo_list,
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

				%__MODULE__{todo_list | entries: new_entries}
		end
	end

	def update_entry(todo_list, %{} = new_entry) do
		update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
	end

	def delete_entry(
				%__MODULE__{entries: entries} = todo_list,
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
				%__MODULE__{todo_list | entries: new_entries}
		end
	end

	# def delete_entry(todo_list, entry_id) do
	# 	%__MODULE__{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
	# end

end