defmodule UserInterface.ChoreTest do
  use UserInterface.ModelCase

  alias UserInterface.Chore

  @valid_attrs %{bonus: true, description: "some content", name: "some content", order: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chore.changeset(%Chore{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chore.changeset(%Chore{}, @invalid_attrs)
    refute changeset.valid?
  end
end
