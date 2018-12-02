defmodule Mentions.Repo do
  use Ecto.Repo,
    otp_app: :mentions,
    adapter: Ecto.Adapters.Postgres

    @moduledoc """
      Define the Repo and its Adapter for the Application.
    """
end
