defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  def join(name, _params, socket) do
    IO.puts(name)
    {:ok, %{message: "Welcome"}, socket}
  end

  def handle_in() do

  end

end
