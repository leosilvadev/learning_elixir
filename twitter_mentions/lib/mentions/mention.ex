defmodule Mentions.Mention do
  require Logger

  import String, only: [to_integer: 1]
  import Ecto.Query
  alias Mentions.Repo

  @months %{"Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Ago" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12}

  @spec search(String.t, Integer.t) :: {list(map()), String.t | map()}
  def search("@" <> _ = mentioned, number_mentions), do:
    next_mentions(mentioned, number_mentions, last_tweet_id(mentioned))

  def search(%{} = metadata, _number_mentions), do:
    next_mentions(metadata)

  @spec last_tweet_id(String.t) :: String.t
  def last_tweet_id(mentioned) do
    Repo.one from m in "mentions",
          where: m.search_for == ^mentioned,
          order_by: [desc: m.created_at],
          limit: 1,
          select: m.tweet_id
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
    %{statuses: statuses, metadata: metadata} = search.()
    %{query: search_for} = metadata

    mentions = statuses
    |> Stream.map(&(to_mention(URI.decode(search_for), &1)))
    |> Enum.to_list

    {mentions, metadata}
  end

  defp to_mention(search_for, %{id_str: id, text: text, created_at: created_at, retweet_count: retweet_count, user: %{screen_name: screen_name}}), do:
    %{tweet_id: id, search_for: search_for, user: screen_name, text: text, created_at: to_datetime(created_at), retweets: retweet_count}

  defp to_datetime(str) do
    [_, month_str, day, time, _, year] = String.split(str)
    [hour, minute, second] = String.split(time, ":")

    {:ok, datetime} = NaiveDateTime.new(
      to_integer(year),
      @months |> Map.get(month_str),
      to_integer(day),
      to_integer(hour),
      to_integer(minute),
      to_integer(second)
    )
    datetime
  end

end
