defmodule UserInterface.AdminController do
  use UserInterface.Web, :controller

  import UserInterface.NetworkConnectionHelper
  alias ChoreRepository

  plug :scrub_params, "chore" when action in [:create, :update]

  # def index(conn, _params) do
  #   connections = current_connections
  #   render(conn, "show.html", connections: connections)
  # end
  #
  # def next(conn, %{"id" => id}) do
  #   chore = ChoreRepository.next(String.to_integer(id))
  #   if chore do
  #     render(conn, "show.html", chore: chore)
  #   else
  #     unmark_result = Task.async(fn -> unmark(conn) end)
  #
  #     render(conn, "done.html", unmark_result: Task.await(unmark_result))
  #   end
  # end
end
