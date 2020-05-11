defmodule TodoList do
  # def new, do: MultiDict.new()

  # def add_entry(todo_list, entry) do
  #   MultiDict.add(todo_list, entry.date, entry)
  # end

  # def entries(todo_list, date) do
  #   MultiDict.get(todo_list, date)
  # end

  defstruct auto_id: 1, entries: Map.new()

  # Creates a new instance
  def new, do: %TodoList{}

  def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
    # Sets the new entry's ID
    entry = Map.put(entry, :id, auto_id)

    # Add new entry in the entries list
    new_entries = Map.put(entries, auto_id, entry)

    # update the struct
    %TodoList{todo_list | entries: new_entries, auto_id: auto_id + 1}
  end

  def entries(%TodoList{entries: entries}, date) do
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
        %TodoList{entries: entries} = todo_list,
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

        %TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(
        %TodoList{entries: entries} = todo_list,
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
        %TodoList{todo_list | entries: new_entries}
    end
  end
end

# TEST FOR Console

# iex(1)> todo_list = TodoList.new |>
# TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
# |> TodoList.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
# |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Movies"})

# iex(2)> TodoList.entries(todo_list, {2013, 12, 19})

# [%{date: {2013, 12, 19}, id: 3, title: "Movies"},
# %{date: {2013, 12, 19}, id: 1, title: "Dentist"}]

defmodule TodoServer do
  def start do
    initial_state = TodoList.new()
    spawn(fn -> loop(initial_state) end)
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        message ->
          process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  def add_entry(todo_server, new_entry) do
    send(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    send(todo_server, {:entries, self, date})

    receive do
      {:todo_queries, entries} ->
        entries
    after
      5000 ->
        {:error, timeout}
    end
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end
end

# you can add support for other to-do list requests such as update_entry and delete_entry
