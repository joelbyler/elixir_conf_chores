defmodule UserInterface.ChoreController do
  use UserInterface.Web, :controller

  import UserInterface.NetworkConnectionHelper
  alias ChoreRepository

  def index(conn, _params) do
    ChoreRepository.next(0)
      |> render_next(conn)
  end

  def next(conn, %{"id" => id}) do
    ChoreRepository.next(String.to_integer(id))
      |> render_next(conn)
  end

  defp render_next(nil, conn) do
    UserInterface.ConnectionTracker.done(mac(conn), ip(conn))
    UserInterface.Endpoint.broadcast("chore:lobby", "fetch_connection_state", %{})
    unmark_result = Task.async(fn -> unmark(conn) end)
    render(conn, "done.html",
      unmark_result: Task.await(unmark_result),
      mac: mac(conn))
  end

  defp render_next(chore, conn) do
    UserInterface.ConnectionTracker.step(mac(conn), ip(conn), chore.id)
    UserInterface.Endpoint.broadcast("chore:lobby", "fetch_connection_state", %{})
    render(conn, "show.html", chore: chore, mac: mac(conn))
  end

  defp ip(conn) do
    user_ip_address(conn)
  end

  defp mac(conn) do
    Plug.Conn.get_session(conn, :mac) || Task.await(fetch_mac(conn))
  end

  defp fetch_mac(conn) do
    Task.async(fn -> user_mac_address(conn) end)
  end

end
