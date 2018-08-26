defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck generates a deck with 20 cards" do
    deck = Cards.create_deck()
    assert length(deck) == 20
  end
end
