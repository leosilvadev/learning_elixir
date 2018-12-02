defmodule Mentions.Mention do

  @type t :: %Mentions.Mention{
    tweet_id: String.t(), search_for: String.t(), user: String.t(), text: String.t(), created_at: NaiveDateTime.t, retweets: Integer.t()
  }

  defstruct tweet_id: nil, search_for: nil, user: nil, text: nil, created_at: nil, retweets: nil

  @moduledoc """
    Represents the domain Mention, that contains all the relevant data from tweeter for our application.
  """
end
