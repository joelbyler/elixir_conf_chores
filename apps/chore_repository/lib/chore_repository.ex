defmodule Chore do
  defstruct id: "", name: "", description: "", required: false
end
defmodule ChoreRepository do
  alias PersistentStorage

  def repository_file do
    Application.get_env(:chore_repository, :config)[:file]
  end

  def setup do
    PersistentStorage.setup path: repository_file
  end

  def insert(name, order, description, required) do
    PersistentStorage.put(order, %{
      id: order,
      name: name,
      description: description,
      required: required
    })
  end

  def next(order) do
     IO.puts "foo"
     order + 1 |> PersistentStorage.get |> map_to_chore
  end

  def map_to_chore(nil) do
  end

  def map_to_chore(map) do
    %Chore{ id: map.id, name: map.name, description: map.description, required: map.required }
  end

  def insert(name, order, description) do
    insert(name, order, description, false)
  end

  def seed do
    insert("Attend Joel's Talk", "1", "I think you'll enjoy it.", "true")
    insert("Tweet at Joel", "2", "His twittler account is @joelbyler")
    insert("Complement your neighbor", "3", "Its good to make friends", "true")
  end

end
