defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    render conn, "index.html", topics: Repo.all(Topic)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => topic_id}) do
    case Repo.one(from t in Topic, where: t.id == ^topic_id, select: t) do
      %Topic{id: _id, title: _title} = topic ->
        changeset = Topic.changeset(topic)
        render conn, "edit.html", changeset: changeset, topic: topic
      nil ->
        conn |> put_flash(:error, "Topic not found") |> redirect(to: topic_path(conn, :index))
    end
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn |> put_flash(:info, "Topic created") |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def update(conn, %{"topic" => new_topic, "id" => topic_id}) do
    current_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(current_topic, new_topic)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn |> put_flash(:info, "Topic update") |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: current_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!
    conn |> put_flash(:info, "Topic deleted") |> redirect(to: topic_path(conn, :index))
  end
end
