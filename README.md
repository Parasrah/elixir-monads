# Monad

> Disclaimer: I would not advise using this package. As I discovered fairly quickly, this pattern relies heavily on the currying that exists in `Elm`, and did not play very nicely when used in `Elixir`. I may come back to this when I have a better understanding of the macro system, maybe something exists there to provide a decent syntax around this.

Adds some monads to elixir, modeled after the implementation in Elm

## Installation

This package can be installed
by adding `monad` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:monad, git: "git@github.com:Parasrah/elixir-monads.git", tag: "0.2"}
  ]
end
```
