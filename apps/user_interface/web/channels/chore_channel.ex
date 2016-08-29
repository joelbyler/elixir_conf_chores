defmodule UserInterface.ChoreChannel do
  use Phoenix.Channel
  alias UserInterface.Presence

  def join("chore:" <> _room_name, _message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.mac, UserInterface.ConnectionTracker.connection(socket.assigns.mac))
    push socket, "presence_state", Presence.list(socket)
    push(socket, "connection_state", %{connections: UserInterface.ConnectionTracker.connections()})
    {:noreply, socket}
  end

  def handle_in("fetch_connection_state", msg, socket) do
    push(socket, "connection_state", %{connections: UserInterface.ConnectionTracker.connections()})
    {:noreply, socket}
  end

  def handle_in("disconnect_user", msg, socket) do
    UserInterface.NetworkConnectionHelper.mark(msg["mac"])
    UserInterface.ConnectionTracker.remove(msg["mac"])
    push(socket, "connection_state", %{connections: UserInterface.ConnectionTracker.connections()})
    {:noreply, socket}
  end

end
