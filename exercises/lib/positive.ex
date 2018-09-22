defmodule Positive do
  @moduledoc """
    Provides functions that returns a list with the positive numbers based in a given list of numbers
  """

  @doc """
    Returns an empty `list` when the given `list` is also empty

  ### Examples

        iex> Positive.positives_of([])
        []
  """
  def positives_of([]), do: []

  @doc """
    Returns a `list` with the positive numbers based on the given `list`, ignoring the first element (when it is not positive)

  ### Examples

        iex> Positive.popositives_of([-1,3,-1,4,-3])
        [4,3]
  """
  def positives_of([head | tail]) when head > 0, do: positives_of([head], tail)

  @doc """
    Returns a `list` with the positive numbers based on the given `list`, including the first element (when it is not positive)

  ### Examples

        iex> Positive.popositives_of([1,3,-1,4,-3])
        [4,3,1]
  """
  def positives_of([head | tail]), do: positives_of([], tail)

  defp positives_of(positives, [head | tail]) when head > 0,
    do: positives_of([head | positives], tail)

  defp positives_of(positives, [head | tail]), do: positives_of(positives, tail)

  defp positives_of(positives, []), do: positives

end
