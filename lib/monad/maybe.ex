defmodule Monad.Maybe do
  @moduledoc """
  A `Maybe` monad modeled after Elm's Maybe type
  """

  @type t :: %__MODULE__{
    value: nil | any
  }
  defstruct value: nil

  alias Monad.Maybe

  @doc """
  Convert an elixir 'maybe' to a `%Maybe` monad

  Also handles `%Maybe` -> `%Maybe`

  ## Examples

    iex> Maybe.from("we know")
    %Maybe{value: "we know"}

    iex> Maybe.from(nil)
    %Maybe{value: nil}

    iex> Maybe.from(Maybe.from(nil))
    %Maybe{value: nil}
  """
  def from(nil), do: %Maybe{value: nil}
  def from(%Maybe{} = maybe), do: maybe
  def from(value), do: %Maybe{value: value}

  defimpl Monad, for: Maybe do
    def and_then(%Maybe{value: nil} = maybe, _), do: maybe
    def and_then(%Maybe{value: value}, op), do: Maybe.from(op.(value))

    def unwrap(%Maybe{value: value}), do: value
  end
end
