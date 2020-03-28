# iexSmix
A new journey of hello world - Learning Elixir
## Books & Courses

- [Getting Started - Elixir](https://elixir-lang.org/getting-started/introduction.html)
- [Crash Course on Elixir](https://elixir-lang.org/crash-course.html)

## Random Topics
- [Pattern Matching - JoyofElixir.com](https://joyofelixir.com/6-pattern-matching/)
- [Map with fat arrow vs colon (Poison - JSON Decode)](https://stackoverflow.com/questions/39340611/map-with-fat-arrow-vs-colon-poison-json-decode)

## Closures

A lambda can reference any variable from the outside scope:

![closure](./closure.png)

As long as you hold the reference to my_lambda, the variable outside_var is also accessible. This is also known as closure: by holding a reference to a lambda, you indirectly hold a reference to all variables it uses, even if those variables are from the external scope.

A closure always captures a specific memory location. Rebinding a variable doesn’t affect the previously defined lambda that references the same symbolic name:

## Higher Level Types

- Range
- Keyword
- HashDict
- HashSet -> MapSet

## Elixir Runtime

**Note:** The important thing to remember from this discussion is that at runtime, module names are atoms. And somewhere on the disk is an xyz.beam file, where xyz is the expanded form of an alias (such as Elixir.MyModule when the module is named MyModule).

## Elixir Commands

-Switch path (-pa)
> $ iex -pa my/code/path -pa another/code/path
-You can check which code paths are used at runtime by calling the Erlang function
> :code.get_path

## Pure Erlang Modules

In Erlang, modules also correspond to atoms. Somewhere on the disk is a file named code.beam that contains the compiled code of the :code module. Erlang uses simple filenames, which is the reason for this call syntax. But the rules are the same as with Elixir modules. In fact, Elixir modules are nothing more than Erlang modules with fancier names (such as Elixir.MyModule).

e.g. `:code.get_path`

```elixir
defmodule :my_module do
  ...
end
```

## Dynamically calling functions

Kernel.apply/3 function receives three arguments: the module atom, the function atom, and the list of arguments passed to the function. Together, these three arguments, often called **MFA** (for module, function, arguments),

> iex(1)> apply(IO, :puts, ["Dynamic function call."])

Dynamic function call

## Running Scripts

If you don’t want a BEAM instance to terminate, you can provide the `--no-halt` parameter:

> $ elixir --no-halt script.exs

This is most often useful if your main code (outside a module) just starts concurrent tasks that perform all the work.

## Summary of chapter 2

- Elixir code is divided into modules and functions.
- Elixir is a dynamic language. The type of a variable is determined by the value it holds.
- Data is immutable—it can’t be modified. A function can return the modified version of the input that resides in another memory location. - The modified version shares as much memory as possible with the original data.
- The most important primitive data types are numbers, atoms, and binaries.
- There is no boolean type. Instead, the atoms true and false are used.
- There is no nullability. The atom nil can be used for this purpose.
- There is no string type. Instead, you can use either binaries (recommended) or lists (when needed).
- The only complex types are tuples, lists, and maps. Tuples are used to group a small, fixed-size number of fields. Lists are used to     manage variable-size collections. A map is a key-value data structure.
- Range, keyword lists, HashDict, and HashSet are abstractions built on top of the existing data system. They aren’t distinct types.
- Functions are first-class citizens.
- Module names are atoms (or aliases) that correspond to beam files on the disk.
- There are multiple ways of starting programs: iex, elixir, and the mix tool.

## Chapter 3: Control Flow

### 3.2.2. [Guards](./guards.exs)

- A guard can be specified by providing the `when` clause after the arguments list

> Type Ordering number < atom < reference < fun < port < pid < tuple < map < list < bitstring (binary)

### Guards Limitations

The set of operators and functions that can be called from guards is very limited. The following operators and functions are allowed

- Comparison operators (==, !=, ===, !==, >, <, <=, >=)
- Boolean operators (and, or) and negation operators (not, !)
- Arithmetic operators (+, -, *, /)
- <> and ++ as long as the left side is a literal
- `in` operator
- Type-check functions from the Kernel module (for example, is_number/1, is_atom/1, and so on)
- Additional Kernel function abs/1, bit_size/1, byte_size/1, div/2, elem/2, hd/1, length/1, map_size/1, node/0, node/1, rem/2, round/1, self/0, tl/1, trunc/1, and tuple_size/1
- [Code](./guard-limitation.exs)

### Multiclause Lambdas (Annonymous Functions)

```elixir

iex(1)> double = fn(x) -> x*2 end  <--------------- Defines a lambda
iex(2)> double.(3) <------------------ Calls a lambda

```

**Syntax**

```elixir

fn
    pattern_1 ->
      ... (Execuated if pattern_1 matches)
    pattern_1 ->
      ... (Execuated if pattern_2 matches)

    ...
end

```
[Code Sample](./multiclause-lambdas)

### Conditionals

#### Branching with Multiclause Functions

  ```elixir
    defmodule TestList do
      def empty?([]), do: true
      def empty?([_|_]), do: false
    end
  ```

  *Description*: The first clause matches the empty list, whereas the second clause relies on the [head | tail] representation of a non-empty list.

We can implement `Polymorphic Functions` e.g.

  ```elixir
    iex(1)> defmodule Polymorphic do
              def double(x) when is_number(x), do: 2 * x

              def double(x) when is_binary(x), do: x <> x
            end

    iex(2)> Polymorphic.double(3) // 6

    iex(3)> Polymorphic.double("Jar") //"JarJar"

  ```

*Recursive Functions*: Calculate factorial

  ```elixir
    defmodule FactorialFind do
      def fact(0), do: 1
      def fact(x), do: n * fact(n-1)
    end
  ```

**File Line Counter**

```elixir
  defmodule LinesCounter do
    def line_reader(path) do
      File.reader(path)
      |> line_num
    end

    defp line_num({:ok, contents}) do
      contents
      |> String.split("\n")
      length
    end

    defp line_num(error), do: error

  end

```elixir
