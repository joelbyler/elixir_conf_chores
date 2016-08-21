defmodule Chore do
  defstruct id: "", name: "", description: "", required: false
end

# defmodule Connection do
#   defstruct mac: "", ip: "", status: "", step: nil
# end

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

#   def step(mac, ip, order) do
#     # PersistentStorage.put("macs", %{mac => %{
#     #   ip: ip,
#     #   step: order,
#     #   status: "wip"
#     # }})
#     #
#     PersistentStorage.put(
#     [
#       macs:
#       {
#         mac,
#         ip,
#         order,
#         "wip"
#       }
#     ])
#
#   end
#
#   def done(mac, ip) do
#     # PersistentStorage.put("macs", %{mac => %{
#     #   ip: ip,
#     #   step: nil,
#     #   status: "done"
#     # }})
#     PersistentStorage.put(
#     [
#       macs: "macs",
#       { mac,
#         ip,
#         nil,
#         "done"
#       }
#     ])
#   end
#
#   def connections do
#     PersistentStorage.get("macs") |> list_to_connections
#   end
# # %{"ab:cd:ef:ab:cd:ef" => %{ip: "127.0.0.1", status: "done", step: nil}}
#   def list_to_connections(list) do
#       IO.puts(list)
#     list.map(map_to_connection(list))
#   end
#
#   def map_to_connection(conn) do
#     # <%= for mac <- @macs do %>
#     # <li><%= elem(mac, 0) %>: <%= elem(mac, 1).status %></li>
#     # <% end %>
#     # IO.puts hd(Map.keys(conn))
#     # mac = hd(Map.keys(conn))
#     # connection_map = tl(Map.keys(conn))
#     "hi"
#     # %Connection{ mac: "mac", ip: "connection_map.ip", status: "connection_map.status", step: "connection_map.step" }
#   end

  def seed do
    # insert("Attend Joel's Talk", "1", "I think you'll enjoy it.", "true")
    # insert("Tweet at Joel", "2", "His twittler account is @joelbyler")
    # insert("Complement your neighbor", "3", "Its good to make friends")

    insert("Make your bed", "1", "So it looks nice and you have a place to sit", "true")
    insert("Exercise", "2", "Do 25 jumping jacks or 10 pushups, to help keep fit")
    insert("Clean your room", "3", "Keep it nice and clean so you have more room to play", "true")
    insert("Give your mom a hug", "4", "Maybe even a kiss, to show her how you love her")
    insert("Put your clothes away", "5", "A place for everything and everything in its place", "true")
    insert("Tell your sister you lover her", "6", "Its good to show others how you feel")
    insert("Tidy up your closet", "7", "Its hard to find anything when its a mess in there", "true")
    insert("Give the pets some attention", "8", "They need love too")
    insert("Put away dirty clothes", "9", "Put them in the hamper so your mother can wash them", "true")

  end

end
