defmodule UserInterface.RoomChannel do
  use Phoenix.Channel
  alias UserInterface.Presence

  def join("room:" <> _room_name, _message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.name, %{
      status: "online"
    })
    IO.puts(Map.keys(Presence.list(socket)))
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{
      body: body,
      author: socket.assigns.name,
    }

    {:noreply, socket}
  end

  def handle_in("new_status", %{"status" => status}, socket) do
    {:ok, _} = Presence.update(socket, socket.assigns.name, %{
      status: status
    })
    {:noreply, socket}
  end
end
