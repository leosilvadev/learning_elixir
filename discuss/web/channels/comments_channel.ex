defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.{Comment, Topic}

  def join("comments:" <> id, _params, socket) do
    %Topic{comments: comments} = topic = Topic
    |> Repo.get(String.to_integer(id))
    |> Repo.preload(:comments)
    {:ok, %{comments: comments}, assign(socket, :topic, topic)}
  end

  def handle_in("comments:add", %{"content" => content}, %{assigns: %{topic: topic}} = socket) do
    changeset = topic
      |> build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} -> {:reply, :ok, socket}
      {:error, _reason} -> {:error, %{errors: changeset}, socket}
    end

    {:reply, :ok, socket}
  end

  def handle_in(name, message, socket) do
    {:reply, :ok, socket}
  end

end
