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
