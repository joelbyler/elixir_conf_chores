defmodule UserInterface.Chore do
  use UserInterface.Web, :model

  schema "chores" do
    field :name, :string
    field :order, :integer
    field :description, :string
    field :bonus, :boolean, default: false

    timestamps
  end

  @required_fields ~w(name order description bonus)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
