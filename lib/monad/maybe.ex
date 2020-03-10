defmodule Monad.Maybe do
  @moduledoc """
  A `Maybe` monad modeled after Elm's Maybe type
  """

  @opaque t() :: %__MODULE__{
    value: nil | term()
  }
  defstruct value: nil

  alias Monad.Maybe
  alias Monad.Result

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
  @spec from(t() | term() | nil) :: t()
  def from(nil), do: %Maybe{value: nil}
  def from(%Maybe{} = maybe), do: maybe
  def from(%Result{status: :error}), do: from(nil)
  def from(%Result{status: :ok, value: value}), do: %Maybe{value: value}
  def from({:error, _}), do: from(nil)
  def from({:ok, value}), do: from(value)
  def from(value), do: %Maybe{value: value}

  defimpl Monad, for: Maybe do
    def and_then(%Maybe{value: nil} = maybe, _), do: maybe
    def and_then(%Maybe{value: value}, op), do: Maybe.from(op.(value))

    def unwrap(%Maybe{value: value}), do: value

    def map(%Maybe{value: nil} = maybe, _), do: maybe
    def map(%Maybe{value: value}, op), do: Maybe.from(op.(value))
  end
end
