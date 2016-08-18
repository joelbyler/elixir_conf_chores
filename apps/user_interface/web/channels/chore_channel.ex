defmodule UserInterface.ChoreChannel do
  use Phoenix.Channel
  alias UserInterface.Presence

  def join("chore:" <> _room_name, _message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # TODO: add this back in: {:ok, _} = Presence.track(socket, socket.assigns.mac, UserInterface.ConnectionTracker.connection(socket.assigns.mac))
    push socket, "presence_state", Presence.list(socket)
    # TODO: add this back in: push(socket, "connection_state", %{connections: UserInterface.ConnectionTracker.connections()})
    {:noreply, socket}
  end

  def handle_in("fetch_connection_state", msg, socket) do
    # TODO: add this back in: push(socket, "connection_state", %{connections: UserInterface.ConnectionTracker.connections()})
    {:noreply, socket}
  end

  def handle_in("disconnect_user", msg, socket) do
    IO.puts msg["mac"]
    UserInterface.NetworkConnectionHelper.mark(msg["mac"])
    {:noreply, socket}
  end

end
