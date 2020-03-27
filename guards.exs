defmodule TestNum do
  def test(x) when x < 0 do
    :negative
  end

  def text(0), do: :zero

  def text(x) when x > 0 do
    :postive
  end
end

defmodule TestNumSecond do
  def test(x) when kernel.is_number(x) and x < 0 do
    :negative
  end

  def test(0), do: :zero

  def test(x) when kernel.is_number(x) and x > 0 do
    :postive
  end
end
