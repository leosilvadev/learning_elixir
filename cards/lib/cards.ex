defmodule Cards do
  @moduledoc """
    Provides methods to create and deal with decks and its cards
  """

  @doc """
    Create a new deck, the cards are sorted by suits and values
    returns a deck, that is a list of cards

  ## Examples

      iex> Cards.create_deck()
      ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
       "Five of Spades", "Ace of Clubs", "Two of Clubs", "Three of Clubs",
       "Four of Clubs", "Five of Clubs", "Ace of Hearts", "Two of Hearts",
       "Three of Hearts", "Four of Hearts", "Five of Hearts", "Ace of Diamonds",
       "Two of Diamonds", "Three of Diamonds", "Four of Diamonds", "Five of Diamonds"]

  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
        "#{value} of #{suit}"
    end
  end

  @doc """
    Create a hand of cards based on the `hand_size` parameter
    returns a tuple with list of cards chosen and the rest

  ## Examples

      iex> {cards, _rest} = Cards.create_hand(2)
      iex> length(cards) == 2
      true

  """
  def create_hand(hand_size) do
    create_deck()
    |> deal(hand_size)
  end

  @doc """
    Shuffle the `deck`
    returns a shuffled deck

  ## Examples

      iex> deck = ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades"]
      iex> shuffled = Cards.shuffle(deck)
      iex> deck != shuffled
      true
      iex> length(deck) == length(shuffled)
      true

  """
  def shuffle(deck) do
    Enum.shuffle deck
  end

  @doc """
    Check if the `deck` contains the given `card`
    returns a boolean, if it contains or not

  ## Examples

      iex> Cards.contains?(["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades"], "Four of Spades")
      true

  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Pick the given `hand_size` of cards from the given `deck`, it returns a tuple where the first
    is the picked cards and the other is the rest of cards.
    The deck is shuffled before the cards are chosen
    returns a list of cards

  ## Examples

      iex> deck = Cards.create_deck()
      iex> {cards, _rest} = Cards.deal(deck, 2)
      iex> length(cards) == 2
      true

  """
  def deal(deck, hand_size) do
    deck
    |> shuffle
    |> Enum.split(hand_size)
  end

  @doc """
    Save the deck in the given file path
    returns :ok or a tuple with :error

  ## Examples

      iex> Cards.save(["Ace of Spades", "Two of Spades"], "myfile.txt")
      :ok
      iex> Cards.save(["Ace of Spades", "Two of Spades"], "/home/invalidpath/myfile.txt")
      :error

  """
  def save(deck, filepath) do
    binary = :erlang.term_to_binary(deck)
    case File.write(filepath, binary) do
      :ok -> :ok
      {:error, _} -> :error
    end
  end

  @doc """
    Load a deck from the given file path
    returns a tuple with :ok and a deck or an :error and the message error

  ## Examples

      iex> deck = ["Ace of Spades", "Two of Spades"]
      iex> Cards.save(deck, "myfile.txt")
      iex> Cards.load("myfile.txt")
      {:ok, ["Ace of Spades", "Two of Spades"]}
      iex> Cards.load("myinvalidfile.txt")
      {:error, "File does not exist"}

  """
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> {:ok, :erlang.binary_to_term(binary)}
      {:error, _} -> {:error, "File does not exist"}
    end
  end
end
