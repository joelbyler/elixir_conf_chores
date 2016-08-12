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
    # insert("Attend Joel's Talk", "1", "I think you'll enjoy it.", "true")
    # insert("Tweet at Joel", "2", "His twittler account is @joelbyler")
    # insert("Complement your neighbor", "3", "Its good to make friends")

    insert("Make your bed", "1", "So it looks nice and you have a place to sit", "true")
    insert("Exercise", "2", "Do 25 jumping jacks, to help keep fit")
    insert("Clean your room", "3", "Keep it nice and clean so you have more room to play", "true")
    insert("Give your mom a hug", "4", "Maybe even a kiss, to show her how you love her")
    insert("Put your clothes away", "5", "A place for everything and everything in its place", "true")
    insert("Tell your sister you lover her", "6", "Its good to show others how you feel")
    insert("Tidy up your closet", "7", "Its hard to find anything when its a mess in there", "true")
    insert("Give the pets some attention", "8", "Olaf and Chleo need love too")
    insert("Put away dirty clothes", "9", "Put them in the hamper so your mother can wash them", "true")

  end

end
