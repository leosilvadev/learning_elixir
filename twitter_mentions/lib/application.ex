defmodule Mentions.Application do
  use Application
  use Supervisor

  def start(_type, _args),
    do: Supervisor.start_link(children(), opts())

  defp children do
    [
      supervisor(Mentions.Endpoint, []),
      supervisor(Mentions.Repo, []),
      worker(Mentions.Worker, [Application.get_env(:mentions, :username)], restart: :transient)
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Mentions.Supervisor
    ]
  end
end
