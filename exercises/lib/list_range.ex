defmodule ListRange do
  @moduledoc """
    Contains functions to count and sum the items of a given list
  """

  @doc """
    Returns `{:error, :invalid_range}` when `n1` is bigger `n2`

  ### Examples

        iex> ListMath.length_of(3, 1)
        {:error, :invalid_range}
  """
  def range_of(n1, n2) when n1 > n2, do: {:error, :invalid_range}

  @doc """
    Returns `{:error, :invalid_range}` when `n1` has the same value of `n2`

  ### Examples

        iex> ListMath.length_of(3, 3)
        {:error, :invalid_range}
  """
  def range_of(n1, n2) when n1 == n2, do: {:error, :invalid_range}

  @doc """
    Returns a list that represents the range between `n1` and `n2`.
    `n1` and `n2` are inclusive.

  ### Examples

        iex> ListMath.length_of(1, 5)
        [5, 4, 3, 2, 1]
  """
  def range_of(n1, n2), do: range_of([n1], n1 + 1, n2)

  defp range_of(list, n1, n2) when n1 == n2, do: [n1 | list]

  defp range_of(list, n1, n2), do: range_of([n1 | list], n1 + 1, n2)

end
