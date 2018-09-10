defmodule Discuss.AuthController do
  use Discuss.Web, :controller

  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    %{
      credentials: %{token: token},
      info: %{email: email},
      provider: provider
    } = auth

    changeset = User.changeset(%User{}, %{email: email, token: token, provider: Atom.to_string(provider)})

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "You were logged out")
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, %User{id: id}} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, id)
        |> redirect(to: topic_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(%{changes: %{email: email}} = changeset) do
    case Repo.get_by(User, email: email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end

end
