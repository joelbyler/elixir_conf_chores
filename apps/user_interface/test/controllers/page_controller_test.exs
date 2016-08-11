defmodule UserInterface.PageControllerTest do
  use UserInterface.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello UserInterface!"
  end
end
