use Mix.Config

config :mentions, Mentions.Repo,
  database: System.get_env("PG_DATABASE"),
  username: System.get_env("PG_USERNAME"),
  password: System.get_env("PG_PASSWORD"),
  hostname: System.get_env("PG_HOSTNAME"),
  port: System.get_env("PG_PORT") || "5432",
  pool_size: String.to_integer(System.get_env("PG_POOL_SIZE") || "20")
