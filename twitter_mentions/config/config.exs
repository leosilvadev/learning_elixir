use Mix.Config

config :extwitter, :oauth, [
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")
]

config :mentions, ecto_repos: [Mentions.Repo]

config :mentions,
  username: System.get_env("MENTIONS_USERNAME"),
  max_mentions: String.to_integer(System.get_env("MENTIONS_MAX_MENTIONS") || "100"), # the limit in twitter api is 100, so a bigger number won't make a difference
  retry_delay: String.to_integer(System.get_env("MENTIONS_RETRY_DELAY") || "60000")

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info

import_config "#{Mix.env()}.exs"
