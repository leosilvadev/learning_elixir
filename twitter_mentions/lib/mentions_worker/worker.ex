defmodule Mentions.Worker do
  require Logger

  alias Mentions.Mention
  alias Mentions.Repo

  def start_link(username) do
    pid = spawn_link(__MODULE__, :init, [username])
    {:ok, pid}
  end

  def init(username) do
    Logger.info "Getting mentions for user #{username} [pid = #{inspect self()}]"
    loop("@#{username}")
    Logger.info "Finishing working execution..."
    :normal
  end

  def loop(metadata) do
    try do
      max_mentions = int_config :max_mentions
      case Mention.search(metadata, max_mentions) do
        {mentions, metadata} when length(mentions) == max_mentions ->
          Logger.info "Found #{length(mentions)} mentions, looking for more..."
          persist(mentions)
          loop(metadata)

        {mentions, _metadata} ->
          Logger.info "Found #{length(mentions)} mentions"
          persist(mentions)
      end
    rescue
      _ in ExTwitter.RateLimitExceededError ->
        retry_delay = int_config :retry_delay
        Logger.error "Request exceeded, waiting for #{retry_delay} milliseconds before retry..."
        Process.sleep retry_delay
        loop(metadata)
    end
  end

  defp int_config(key), do: String.to_integer Application.get_env(:mentions, key)

  defp persist(mentions) do
    Logger.info "Persisting #{length(mentions)} mentions"
    Repo.insert_all("mentions", mentions)
  end

end
