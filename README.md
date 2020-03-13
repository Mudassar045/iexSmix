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