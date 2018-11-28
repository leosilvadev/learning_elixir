defmodule Mentions.Application do
  use Application

  def start(_type, _args),
    do: Supervisor.start_link(children(), opts())

  defp children do
    [Mentions.Endpoint]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Mentions.Supervisor
    ]
  end
end
