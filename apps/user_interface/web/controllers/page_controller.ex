defmodule UserInterface.PageController do
  use UserInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
