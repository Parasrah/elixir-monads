defprotocol Monad do
  @type t :: term()

  @doc """
  Perform an operation that could produce another monad

  ## Examples

    iex> "we" |> Monad.Maybe.from() |> Monad.and_then(&(&1 <> " know"))
    %Monad.Maybe{value: "we know"}

  """
  @spec and_then(t(), (t() -> t())) :: t()
  def and_then(monad, op)

  @doc """
  Unwrap monad into corresponding elixir data structure

  ## Examples
  
    iex> "we know" |> Monad.Maybe.from() |> Monad.unwrap()
    "we know"

  """
  @spec unwrap(t()) :: term()
  def unwrap(monad)

  @doc """
  Map the inner value of a monad

  ## Examples

  iex> Monad.Maybe.from("Elixir is") |> Monad.map(&(&1 <> " awesome!"))
  %Monad.Maybe{value: "Elixir is awesome!"}

  """
  @spec map(t(), (term() -> term())) :: t()
  def map(monad, op)
end
