defmodule Mentions.Controller do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    config = %{
      username: Application.get_env(:mentions, :username),
      max_mentions: Application.get_env(:mentions, :max_mentions),
      retry_delay: Application.get_env(:mentions, :retry_delay)
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{config: config}))
  end
end
