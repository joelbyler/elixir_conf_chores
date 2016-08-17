defmodule UserInterface.ChoreController do
  use UserInterface.Web, :controller

  import UserInterface.NetworkConnectionHelper
  alias ChoreRepository

  def index(conn, _params) do
    chore = ChoreRepository.next(0)

    render(conn, "show.html", chore: chore, mac: mac(conn))
  end

  def next(conn, %{"id" => id}) do
    UserInterface.ConnectionTracker.step(mac(conn), ip(conn), id)
    # ChoreRepository.step(mac(conn), ip(conn), id)
    ChoreRepository.next(String.to_integer(id))
      |> render_next(conn)
  end

  defp render_next(nil, conn) do
    unmark_result = Task.async(fn -> unmark(conn) end)
    UserInterface.ConnectionTracker.done(mac(conn), ip(conn))
    # connections = UserInterface.ConnectionTracker.connections
    connections = Task.async(fn -> UserInterface.ConnectionTracker.connections() end)
    render(conn, "done.html",
      unmark_result: Task.await(unmark_result),
      mac: mac(conn),
      connections: Task.await(connections))
  end

  defp render_next(chore, conn) do
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
