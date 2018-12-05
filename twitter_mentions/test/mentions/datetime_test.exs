defmodule Mentions.DatetimeTest do
  use ExUnit.Case

  test "Should parse a valid datime" do
    {:ok, expected} = NaiveDateTime.new(2018, 2, 25, 18, 11, 01)
    datetime = Mentions.Datetime.parse("Sun Feb 25 18:11:01 +0000 2018")
    assert expected == datetime
  end

  test "Should fail on invalid datetime format" do
    assert is_nil(Mentions.Datetime.parse("10-09-2018 11:02:05")) == true
  end
end
