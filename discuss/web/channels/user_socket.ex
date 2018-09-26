defmodule Discuss.UserSocket do
  use Phoenix.Socket

  alias Discuss.Repo
  alias Discuss.User

  ## Channels
  channel "comments:*", Discuss.CommentsChannel

  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    with {:ok, user_id} <- Phoenix.Token.verify(Discuss.Endpoint, "key", token) do
      {:ok, assign(socket, :user_id, user_id)}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Discuss.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
