defmodule UserInterface.ChoreControllerTest do
  use UserInterface.ConnCase

  alias UserInterface.Chore
  @valid_attrs %{bonus: true, description: "some content", name: "some content", order: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chore_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing chores"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, chore_path(conn, :new)
    assert html_response(conn, 200) =~ "New chore"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, chore_path(conn, :create), chore: @valid_attrs
    assert redirected_to(conn) == chore_path(conn, :index)
    assert Repo.get_by(Chore, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chore_path(conn, :create), chore: @invalid_attrs
    assert html_response(conn, 200) =~ "New chore"
  end

  test "shows chosen resource", %{conn: conn} do
    chore = Repo.insert! %Chore{}
    conn = get conn, chore_path(conn, :show, chore)
    assert html_response(conn, 200) =~ "Show chore"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, chore_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    chore = Repo.insert! %Chore{}
    conn = get conn, chore_path(conn, :edit, chore)
    assert html_response(conn, 200) =~ "Edit chore"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    chore = Repo.insert! %Chore{}
    conn = put conn, chore_path(conn, :update, chore), chore: @valid_attrs
    assert redirected_to(conn) == chore_path(conn, :show, chore)
    assert Repo.get_by(Chore, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chore = Repo.insert! %Chore{}
    conn = put conn, chore_path(conn, :update, chore), chore: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit chore"
  end

  test "deletes chosen resource", %{conn: conn} do
    chore = Repo.insert! %Chore{}
    conn = delete conn, chore_path(conn, :delete, chore)
    assert redirected_to(conn) == chore_path(conn, :index)
    refute Repo.get(Chore, chore.id)
  end
end
