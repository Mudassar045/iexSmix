import MultiDict

# initial implementation
defmodule ExampleTodo do
  # step-1
  def new, do: Map.new()

  # step-2
  def add_entry(todo_list, date, title) do
    Map.update(
      todo_list,
      date,
      [title],
      fn titles -> [title | titles] end
    )
  end

  # step-3
  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end

defmodule TodoList do
  def new, do: MultiDict.new()

  def add_entry(todo_list, entry) do
    MultiDict.add(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end
