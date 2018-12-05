defmodule Mentions.Manager do
  require Logger

  import Ecto.Query

  @moduledoc """
    Contains functions used to handle one or more `Mentions.Mention`.
    A Mention is a tweet that mentions a specific username.
  """

  @doc """
    Search for mentions to a given `mentioned` username or a given `metadata` (result from a previous search).
    The result won't return more than a givne `number_mentions`.
    Important: in Twitter, we cannot request more then 100 tweets at one call, so passing more than 100 as `number_mentions` will just return up to 100.

  ### Examples

      iex> Mentions.Manager.search("metallica", 1)
      {[
        %Mentions.Mention{
          created_at: ~N[2018-12-02 07:50:42],
          retweets: 1359,
          search_for: "@metallica",
          text: "@Metallica is just great!",
          tweet_id: "1063136713090846147",
          user: "leosilvadev"
        }
      ],
      %{
        completed_in: 0.09,
        count: 1,
        max_id: 1063136713090846149,
        max_id_str: "1063136713090846149",
        next_results: "?max_id=1063136713090846146&q=%40metallica&count=1&include_entities=1",
        query: "%40metallica",
        refresh_url: "?since_id=1063136713090846149&q=%40metallica&include_entities=1",
        since_id: 0,
        since_id_str: "0"
      }}

      iex> metadata = %{
        completed_in: 0.09,
        count: 1,
        max_id: 1069136951289102335,
        max_id_str: "1069136951289102335",
        next_results: "?max_id=1069136763019440128&q=%40metallica&count=1&include_entities=1",
        query: "%40metallica",
        refresh_url: "?since_id=1069136951289102335&q=%40metallica&include_entities=1",
        since_id: 0,
        since_id_str: "0"
      }
      iex> Mentions.Manager.search("metallica", metadata)
      {[
        %Mentions.Mention{
          created_at: ~N[2018-12-02 07:52:53],
          retweets: 100,
          search_for: "@metallica",
          text: "@Metallica is just great 2!",
          tweet_id: "1069136951289102334",
          user: "leosilvadev"
        }
      ],
      %{
        completed_in: 0.09,
        count: 1,
        max_id: 1069136951289102339,
        max_id_str: "1069136951289102339",
        next_results: "?max_id=1069136951289102333&q=%40metallica&count=1&include_entities=1",
        query: "%40metallica",
        refresh_url: "?since_id=1069136951289102339&q=%40metallica&include_entities=1",
        since_id: 0,
        since_id_str: "0"
      }}
  """
  @spec search(String.t, integer) :: {list(map()), String.t | map()}
  def search("@" <> _ = mentioned, number_mentions), do:
    next_mentions(mentioned, number_mentions, last_tweet_id(mentioned))

  def search(%{} = metadata, _number_mentions), do:
    next_mentions(metadata)

  @doc """
    Fetch the id of the last mention to a given `mentioned` username.

  ### Examples

      iex> Mentions.Manager.last_tweet_id("metallica")
      "379283798237928312"

      iex> Mentions.Manager.last_tweet_id("invalidusername")
      nil
  """
  @spec last_tweet_id(String.t) :: String.t | nil
  def last_tweet_id(mentioned) do
    Mentions.Repo.one from m in "mentions",
          where: m.search_for == ^mentioned,
          order_by: [desc: m.created_at],
          limit: 1,
          select: m.tweet_id
  end

  @doc """
    Persist the list of given `mentions` to the database in batch.

  ### Examples

      iex> mentions = [
        %Mentions.Mention{
          created_at: ~N[2018-12-02 07:52:53],
          retweets: 100,
          search_for: "@metallica",
          text: "@Metallica is just great 2!",
          tweet_id: "1069136951289102334",
          user: "leosilvadev"
        }
      ]
      iex> Mentions.Manager.persist(mentions)
      1

      iex> Mentions.Manager.persist([])
      0
  """
  @spec persist(list(Mentions.Mention.t)) :: integer()
  def persist(mentions) do
    Logger.info "Persisting #{length(mentions)} mentions"
    maps = mentions |> Enum.map(&(Map.from_struct(&1)))
    {total_inserted, _} = Mentions.Repo.insert_all("mentions", maps)
    Logger.info "#{total_inserted} mentions were persisted in the database"
    total_inserted || 0
  end

  defp next_mentions("@" <> _ = mentioned, number_mentions, nil), do:
    next_mentions(fn () -> ExTwitter.search(mentioned, count: number_mentions, search_metadata: true) end)

  defp next_mentions("@" <> _ = mentioned, number_mentions, last_tweet) do
    Logger.info "A mention about #{mentioned} was found (#{last_tweet}), fetching all the mentions after this one"
    next_mentions(fn () -> ExTwitter.search(mentioned, count: number_mentions, since_id: last_tweet, search_metadata: true) end)
  end

  defp next_mentions(%{} = metadata), do:
    next_mentions(fn () -> ExTwitter.search_next_page(metadata) end)

  defp next_mentions(search) do
    with %{statuses: statuses, metadata: metadata} <- search.(),
         %{query: encoded_search_for} <- metadata,
         "@" <> _ = search_for <- URI.decode(encoded_search_for),
         mentions <- Mentions.Mention.parse(search_for, statuses) do

      {mentions, metadata}

      else details -> {:error, "Not possible to get the next mentions. [#{details}]"}
    end
  end

end
