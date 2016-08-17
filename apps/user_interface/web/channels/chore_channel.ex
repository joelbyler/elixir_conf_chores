defmodule UserInterface.ChoreChannel do
  use Phoenix.Channel
  alias UserInterface.Presence

  def join("chore:" <> _room_name, _message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.mac, %{ status: "online" })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end
end
