defmodule Mentions.Worker do
  require Logger
  use GenServer

  alias Mentions.Manager

  @moduledoc """
    Worker is responsible for fetching and persisting all the tweets that mention a specific username.
  """

  @spec start_link(String.t, Integer.t, Integer.t) :: {:ok, String.t}
  def start_link(username, max_mentions, retry_delay) do
    pid = spawn_link(__MODULE__, :init, [[username, max_mentions, retry_delay]])
    {:ok, pid}
  end

  @spec init(list(String.t | Integer.t)) :: {:ok, any()}
  def init([username, max_mentions, retry_delay] = args) do
    Logger.info "Getting mentions for user #{username} [pid = #{inspect self()}]"
    loop("@#{username}", max_mentions, retry_delay)
    Logger.info "Finishing working execution..."
    :normal
    {:ok, args}
  end

  @doc """
    Search for the mentions for a given `query`. A `query` can be either an username or a metadata from a previous search.
    The resulted mentions are inserted into the database.
    All the mentions are fetched and inserted in batch, depending on the given `max_mentions` number.
    When there are no more mentions to be fetched, the method ends.
    In case of exceeding the limit of request in Tweeter, the process waits for the given `retry_delay` before try again.
  """
  @spec loop(String.t | map, Integer.t, Integer.t) :: :done
  def loop(query, max_mentions, retry_delay) do
    try do
      case Manager.search(query, max_mentions) do
        {mentions, metadata} when length(mentions) == max_mentions ->
          Logger.info "Found #{length(mentions)} mentions, looking for more..."
          Manager.persist(mentions)
          loop(metadata, max_mentions, retry_delay)

        {mentions, _metadata} ->
          Logger.info "Found #{length(mentions)} mentions"
          Manager.persist(mentions)
          :done

      end
    rescue
      _ in ExTwitter.RateLimitExceededError ->
        Logger.error "Request exceeded, waiting for #{retry_delay} milliseconds before retry..."
        Process.sleep retry_delay
        loop(query, max_mentions, retry_delay)
    end
  end

end
