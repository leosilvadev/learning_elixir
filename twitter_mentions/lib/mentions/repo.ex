defmodule Mentions.Repo do
  use Ecto.Repo,
    otp_app: :mentions,
    adapter: Ecto.Adapters.Postgres
end
