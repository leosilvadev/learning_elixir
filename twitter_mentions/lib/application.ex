defmodule Mentions.Application do
  use Application
  use Supervisor

  @moduledoc """
    Define the Application and its child processes.
  """

  @doc """
    Start the application and its child processes.
    All the required configuration used from its processes is loaded.
  """
  @spec start(any(), any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start(_type, _args), do:
      Supervisor.start_link(children(), opts())

  defp children do
    username = Application.get_env(:mentions, :username)
    max_mentions = Application.get_env(:mentions, :max_mentions)
    retry_delay = Application.get_env(:mentions, :retry_delay)
    [
      supervisor(Mentions.Repo, []),
      worker(Mentions.Worker, [username, max_mentions, retry_delay], restart: :transient)
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Mentions.Supervisor
    ]
  end
end
