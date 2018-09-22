defmodule Positive do

  def positives_of([]), do: []

  def positives_of([head | tail]) when head >= 0, do: positives_of([head], tail)

  def positives_of([head | tail]), do: positives_of([], tail)

  defp positives_of(positives, [head | tail]) when head >= 0,
    do: positives_of([head | positives], tail)

  defp positives_of(positives, [head | tail]), do: positives_of(positives, tail)

  defp positives_of(positives, []), do: positives

end
