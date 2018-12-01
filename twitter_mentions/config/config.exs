# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :mentions, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:mentions, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

config :extwitter, :oauth, [
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")
]

config :mentions, Mentions.Endpoint, port: 8080

config :mentions, ecto_repos: [Mentions.Repo]

config :mentions,
  username: System.get_env("MENTIONS_USERNAME") || "leosilvadev",
  max_mentions: System.get_env("MENTIONS_MAX_MENTIONS") || "100", # the limit in twitter api is 100, so a bigger number won't make a difference
  retry_delay: System.get_env("MENTIONS_RETRY_DELAY") || "60000"

config :mentions, Mentions.Repo,
  database: "mentions",
  username: "postgres",
  password: "root",
  hostname: "localhost",
  port: "5432"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: System.get_env("APP_LOG_LEVEL") || :info
