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
end

# TEST FOR Console

# iex(1)> todo_list = TodoList.new |>
#          TodoList.add_entry(
#              %{date: {2013, 12, 19}, title: "Dentist"}
#          ) |>

#          TodoList.add_entry(
#            %{date: {2013, 12, 20}, title: "Shopping"}
#          ) |>

#          TodoList.add_entry(
#            %{date: {2013, 12, 19}, title: "Movies"}
#          )

# iex(2)> TodoList.entries(todo_list, {2013, 12, 19})

# [%{date: {2013, 12, 19}, id: 3, title: "Movies"},
# %{date: {2013, 12, 19}, id: 1, title: "Dentist"}]
