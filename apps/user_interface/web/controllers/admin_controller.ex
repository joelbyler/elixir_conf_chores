defmodule UserInterface.AdminController do
  use UserInterface.Web, :controller

  import UserInterface.NetworkConnectionHelper
  alias ChoreRepository

  plug :scrub_params, "chore" when action in [:create, :update]

  def index(conn, _params) do
    render_connections(conn, true) # admin_mac?(mac(conn)))
  end

  def render_connections(conn, true) do
    connections = Task.async(fn -> UserInterface.ConnectionTracker.connections() end)
    render(conn, "index.html", mac: mac(conn), connections: Task.await(connections))
  end

  def render_connections(conn, _) do
    redirect(conn, to: "/")
  end

  def disconnect_user(conn, %{"mac" => mac}) do
    UserInterface.NetworkConnectionHelper.mark(mac)
    UserInterface.ConnectionTracker.remove(mac)
    redirect(conn, to: "/connections")
  end

  defp mac(conn) do
    Plug.Conn.get_session(conn, :mac) || Task.await(fetch_mac(conn))
  end

  defp fetch_mac(conn) do
    Task.async(fn -> user_mac_address(conn) end)
  end

end
