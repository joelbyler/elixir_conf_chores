defmodule UserInterface.ChoreController do
  use UserInterface.Web, :controller

  import UserInterface.NetworkConnectionHelper
  alias ChoreRepository

  def index(conn, _params) do
    chore = ChoreRepository.next(0)
    render(conn, "show.html", chore: chore)
  end

  def next(conn, %{"id" => id}) do
    chore = ChoreRepository.next(String.to_integer(id))
    if chore do
      render(conn, "show.html", chore: chore)
    else
      unmark_result = Task.async(fn -> unmark(conn) end)

      render(conn, "done.html", unmark_result: Task.await(unmark_result))
    end
  end
end
