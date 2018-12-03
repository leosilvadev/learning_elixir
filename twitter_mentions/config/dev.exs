use Mix.Config

config :mentions, Mentions.Repo,
  database: "mentions",
  username: "postgres",
  password: "root",
  hostname: "localhost",
  port: "5432",
  pool_size: 10
