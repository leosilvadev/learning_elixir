defmodule ListLength do
  @moduledoc """
    Contains functions to count items of a given list
  """

  @doc """
    Returns `0` when the list is empty

  ### Examples

        iex> ListMath.length_of([])
        0
  """
  def length_of([]), do: 0

  @doc """
    Returns the total number of elements existent in the given list

  ### Examples

        iex> ListMath.length_of([10,10,23,12])
        4
  """
  def length_of([_ | tail]), do: length_of(1, tail)

  defp length_of(counter, []), do: counter

  defp length_of(counter, [_ | tail]), do: length_of(counter + 1, tail)

end
