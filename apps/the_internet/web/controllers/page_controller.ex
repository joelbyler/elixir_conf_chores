defmodule TheInternet.PageController do
  use TheInternet.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
