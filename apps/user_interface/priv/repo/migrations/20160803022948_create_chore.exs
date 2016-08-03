defmodule UserInterface.Repo.Migrations.CreateChore do
  use Ecto.Migration

  def change do
    create table(:chores) do
      add :name, :string
      add :order, :integer
      add :description, :string
      add :bonus, :boolean, default: false

      timestamps
    end

  end
end
