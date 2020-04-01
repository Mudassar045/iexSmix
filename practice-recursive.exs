defmodule ListHelper do
  def length_func([]), do: 0

  def length_func(counter \\ 1, [head | tail]) do
    if(tail == []) do
      counter
    else
      counter = counter + 1
      length_func(counter, tail)
    end
  end
end

defmodule MathRange do
  def get_list(a, b) do
    if (a == b) do
        []
    else

  end
end
