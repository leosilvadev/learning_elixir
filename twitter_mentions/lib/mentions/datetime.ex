defmodule Mentions.Datetime do

  import String, only: [to_integer: 1]

  @months %{"Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Ago" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12}

  def parse(str) do

    with [_, month_str, day, time, _, year] <- String.split(str),
         [hour, minute, second]             <- String.split(time, ":") do

      {:ok, datetime} = NaiveDateTime.new(
        to_integer(year),
        @months |> Map.get(month_str),
        to_integer(day),
        to_integer(hour),
        to_integer(minute),
        to_integer(second)
      )
      datetime

      else _ -> nil
    end
  end

end
