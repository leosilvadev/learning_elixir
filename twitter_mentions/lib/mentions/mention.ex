defmodule Mentions.Mention do

  @type t :: %Mentions.Mention{
    tweet_id: String.t(), search_for: String.t(), user: String.t(), text: String.t(), created_at: NaiveDateTime.t, retweets: Integer.t()
  }

  defstruct tweet_id: nil, search_for: nil, user: nil, text: nil, created_at: nil, retweets: nil

  @moduledoc """
    Represents the domain Mention, that contains all the relevant data from tweeter for our application.
  """

  @type status_t :: %{
    created_at: String.t,
    id_str: String.t,
    retweet_count: Integer.t,
    text: String.t,
    user: %{screen_name: String.t}
  }

  @spec parse(String.t, Mentions.Mention.status_t | list(Mentions.Mention.status_t)) :: Mentions.Mention.t | list(Mentions.Mention.t)
  def parse(search_for, %{id_str: id, text: text, created_at: created_at, retweet_count: retweet_count, user: %{screen_name: screen_name}}), do:
    %Mentions.Mention{tweet_id: id, search_for: search_for, user: screen_name, text: text, created_at: Mentions.Datetime.parse(created_at), retweets: retweet_count}

  def parse(search_for, []), do: []

  def parse(search_for, [%{id_str: id, text: text, created_at: created_at, retweet_count: retweet_count, user: %{screen_name: screen_name}} | _] = mentions) do
    mentions
    |> Stream.map(&(parse(search_for, &1)))
    |> Enum.to_list
  end

end
