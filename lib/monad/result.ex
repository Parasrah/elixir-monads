defmodule Monad.Result do
  @moduledoc """
  A `Result` monad modeled after Elm's Result type
  """

  @type t :: %__MODULE__{
    status: :ok | :error,
    value: any
  }
  defstruct status: :error, value: nil

  alias Monad.Result

  @doc """
  Convert an elixir 'result' to a `%Result` monad

  ## Examples

    iex> Result.from({:ok, "hello"})
    %Result{status: :ok, value: "hello"}

    iex> Result.from({:ok, Result.ok("hello")})
    %Result{status: :ok, value: "hello"}

    iex> Result.from({:error, "an error"})
    %Result{status: :error, value: "an error"}

    iex> Result.from({:error, Result.err("an error")})
    %Result{status: :error, value: "an error"}

    iex> Result.from(Result.from({:ok, "hello"}))
    %Result{status: :ok, value: "hello"}

    iex> Result.from("not a result")
    %Result{status: :error, value: "attempted to create a result from 'not a result'. Please use `Result.ok` or `Result.err` to create results in this way"}

  """
  @spec from(value :: any) :: BlogCore.Result.t
  def from({:ok, %Result{} = value}), do: ok(value)
  def from({:ok, value}), do: ok(value)
  def from({:error, %Result{} = value}), do: err(value)
  def from({:error, value}), do: err(value)
  def from(%Result{} = result), do: result
  def from(input), do: %Result{status: :error, value: "attempted to create a result from '" <> input <> "'. Please use `Result.ok` or `Result.err` to create results in this way"}

  @doc """
  Convert a value to an `ok` result

  ## Examples

    iex> Result.ok("hello")
    %Result{status: :ok, value: "hello"}

    iex> Result.ok(Result.ok("hello"))
    %Result{status: :ok, value: "hello"}

  """
  @spec ok(any()) :: Monad.Result.t()
  def ok(%Result{status: :ok} = result), do: result
  def ok(%Result{status: :error}), do: raise "attempted to create `ok` result from `error` result"
  def ok(value), do: %Result{status: :ok, value: value}

  @doc """
  Convert a value to an `err` result

  ## Examples

    iex> Result.err("hello")
    %Result{status: :error, value: "hello"}

    iex> Result.err(Result.err("hello"))
    %Result{status: :error, value: "hello"}

  """
  @spec err(any()) :: Monad.Result.t()
  def err(%Result{status: :error} = result), do: result
  def err(%Result{status: :ok}), do: raise "attempted to create `error` result from `ok` result"
  def err(value), do: %Result{status: :error, value: value}

  @doc """
  Convert a result to a `Maybe`

  ## Examples
  
    iex> Result.from_maybe(Monad.Maybe.from(nil), "could not find user")
    %Result{status: :error, value: "could not find user"}

    iex> Result.from_maybe(Monad.Maybe.from("parasrah"), "could not find user")
    %Result{status: :ok, value: "parasrah"}
  """
  @spec from_maybe(Monad.Maybe.t(), String.t()) :: Result.t()
  def from_maybe(maybe, error_value) do
    case Monad.unwrap(maybe) do
      nil -> err(error_value)
      ok_value -> ok(ok_value)
    end
  end

  @doc """
  Similar to and_then, but performs operation on `:error`

  ## Examples
  
    iex> Result.err("I had an issue") |> Result.map_err(&(Result.ok(&1 <> " with being too awesome")))
    %Result{status: :ok, value: "I had an issue with being too awesome"}

  """
  # @spec map_err(Monad.Result.t(), (Monad.Result.t() -> Monad.Result.t())) :: Monad.Result.t()
  def map_err(%Result{status: :ok} = result, _), do: result
  def map_err(%Result{status: :error, value: value}, op), do: Result.from(op.(value))

  defimpl Monad, for: Result do
    def and_then(%Result{status: :ok, value: value}, op), do: Result.from(op.(value))
    def and_then(%Result{status: :error} = result, _), do: result
    def and_then(other, op), do: Result.and_then(Result.from(other), op)

    def unwrap(%Result{status: status, value: value}), do: {status, value}

    def map(%Result{status: :ok, value: value}, op), do: Result.ok(op.(value))
    def map(%Result{status: :error} = result), do: result
  end
end
