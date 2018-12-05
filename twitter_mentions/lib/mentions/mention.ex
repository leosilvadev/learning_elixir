defmodule Mentions.Mention do

  @type t :: %Mentions.Mention{
    tweet_id: String.t(), search_for: String.t(), user: String.t(), text: String.t(), created_at: NaiveDateTime.t, retweets: Integer.t()
  }

  defstruct tweet_id: nil, search_for: nil, user: nil, text: nil, created_at: nil, retweets: nil

  @moduledoc """
    Represents the domain Mention, that contains all the relevant data from tweeter for our application.
  """

  @spec new(String.t, map()) :: Mentions.Mention
  def new(search_for, %{id_str: id, text: text, created_at: created_at, retweet_count: retweet_count, user: %{screen_name: screen_name}}), do:
    %Mentions.Mention{tweet_id: id, search_for: search_for, user: screen_name, text: text, created_at: Mentions.Datetime.parse(created_at), retweets: retweet_count}

end
