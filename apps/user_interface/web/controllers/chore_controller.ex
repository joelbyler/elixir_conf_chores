defmodule UserInterface.ChoreController do
  use UserInterface.Web, :controller

  import UserInterface.NetworkConnectionHelper
  alias ChoreRepository

  def index(conn, _params) do
    IO.puts "Index #{UserInterface.ConnectionTracker.connection(mac(conn)).step}"

    default_chore(mac(conn))
      |> render_chore(conn)

    # UserInterface.ConnectionTracker.connection(mac(conn)).step
    #   |> ChoreRepository.fetch
    #   |> render_first(conn)
  end

  defp default_chore(mac) do
    chore = active_chore(mac)
    if chore == nil || chore.id == 0 do
      chore = ChoreRepository.next(0)
    end
    chore
  end

  defp active_chore(mac) do
    UserInterface.ConnectionTracker.connection(mac).step
      |> ChoreRepository.fetch
  end

  def next(conn, %{"id" => id}) do
    IO.puts "Next: #{mac(conn)}; #{id}"
    next_chore(String.to_integer(id))
      |> render_chore(conn)


    # ChoreRepository.next(String.to_integer(id))
    #   |> render_next(conn)
  end

  defp next_chore(id) do
    ChoreRepository.next(id)
  end

  defp render_chore(nil, conn) do
    IO.puts "Render with default"
    UserInterface.ConnectionTracker.done(mac(conn), ip(conn))
    unmark_result = Task.async(fn -> unmark(conn) end)
    render(conn, "done.html",
      unmark_result: Task.await(unmark_result),
      mac: mac(conn))
  end

  defp render_chore(%Chore{ id: 0 }, conn) do
    IO.puts "Render with default"
    UserInterface.ConnectionTracker.done(mac(conn), ip(conn))
    unmark_result = Task.async(fn -> unmark(conn) end)
    render(conn, "done.html",
      unmark_result: Task.await(unmark_result),
      mac: mac(conn))
  end

  defp render_chore(chore, conn) do
    IO.puts "Render with chore: #{chore.id}"
    UserInterface.ConnectionTracker.step(mac(conn), ip(conn), chore.id)
    render(conn, "show.html", chore: chore, mac: mac(conn))
  end

  # defp render_first(nil, conn) do
  #   IO.puts "First: #{mac(conn)}"
  #   chore = ChoreRepository.next(0)
  #   UserInterface.ConnectionTracker.step(mac(conn), ip(conn), chore.id)
  #   render(conn, "show.html", chore: chore, mac: mac(conn))
  # end
  #
  # defp render_first(chore, conn) do
  #   IO.puts "FirstX: #{mac(conn)}"
  #
  #   UserInterface.ConnectionTracker.step(mac(conn), ip(conn), chore.id)
  #   render(conn, "show.html", chore: chore, mac: mac(conn))
  # end
  #
  # defp render_next(%Chore{ id: 0 }, conn) do
  #   UserInterface.ConnectionTracker.done(mac(conn), ip(conn))
  #   unmark_result = Task.async(fn -> unmark(conn) end)
  #   render(conn, "done.html",
  #     unmark_result: Task.await(unmark_result),
  #     mac: mac(conn))
  # end
  #
  # defp render_next(chore, conn) do
  #   UserInterface.ConnectionTracker.step(mac(conn), ip(conn), chore.id)
  #   render(conn, "show.html", chore: chore, mac: mac(conn))
  # end

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
