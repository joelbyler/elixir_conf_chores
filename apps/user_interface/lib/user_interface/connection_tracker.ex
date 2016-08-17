defmodule Connection do
  defstruct mac: "", ip: "", status: "", step: false
end

defmodule UserInterface.ConnectionTracker do
  use GenServer

  # Client API

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def step(mac, ip, step) do
    GenServer.cast(:connection_tracker, {:step, mac, ip, step})
  end

  def done(mac, ip) do
    GenServer.cast(:connection_tracker, {:done, mac, ip})
  end

  def connections do
    IO.puts "here"
    GenServer.call(:connection_tracker, {:connections})
  end
  def connection(server, name) do
    GenServer.call(server, {:lookup, name})
  end
  # Server implementation

  def init([]) do
    connections = %{}
    {:ok, connections}
  end

  def handle_cast({:step, mac, ip, step}, connections) do
    IO.puts "next step, #{mac}, #{ip}, #{step}"
    {:noreply, Map.put(connections, mac, %{ip: ip, status: "wip", step: step}) }
  end

  def handle_cast({:done, mac, ip}, connections) do
    {:noreply, Map.put(connections, mac, %{ip: ip, status: "done", step: nil}) }
  end

  def handle_call({:connections}, _from, connections) do
    {:reply, map_to_connection_list(connections), connections}
  end

  def handle_call(msg, _from, state) do
    IO.puts "WARNING: default call in GenServer"
    {:reply, :ok, state}
  end
  def handle_cast(_msg, state) do
    IO.puts "WARNING: default cast in GenServer"
    {:noreply, state}
  end

  def stop(server) do
    GenServer.call(server, :stop)
  end

  defp map_to_connection_list(connections) do
    Enum.map(Map.to_list(connections), fn(connection) ->
      struct(%Connection{ mac: hd(Tuple.to_list(connection))}, hd(tl(Tuple.to_list(connection))))
    end)
  end

end

# defmodule UserInterface.ConnectionTracker do
#   use GenServer
#
#   def start_link(opts \\ []) do
#     {:ok, _pid} = GenServer.start_link(ConnectionTracker, [
#       {:ets_table_name, :connection_tracker_table},
#       {:log_limit, 100}
#     ], opts)
#   end
#
#   def step(mac, ip, order) do
#     GenServer.cast(:step, {mac, ip, order})
#   end
#
#   def done(mac, ip) do
#     GenServer.cast(:done, {mac, ip})
#   end
#
#   def connections do
#     GenServer.call(pid, :connections)
#   end
#
#   def stop(server) do
#     GenServer.call(server, :stop)
#   end
#
#   def init(args) do
#
#     [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args
#
#     :ets.new(ets_table_name, [:named_table, :set, :private])
#
#     {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
#   end
#
#    def handle_call(:stop, _from, state) do
#     {:stop, :normal, :ok, state}
#   end
#
#   def handle_cast({:step, mac, ip, order}, state) do
#     {:noreply, Map.put(state, mac, %{ip: ip, status: "wip", step: order})}
#   end
#
#   def handle_cast({:stop, mac, ip}, state) do
#     {:noreply, Map.put(state, mac, %{ip: ip, status: "done", step: nil})}
#   end
#
#
#   def handle_call({room, message}, _from, state) do
#     %{ets_table_name: ets_table_name} = state
#     result = log_message(room, message, ets_table_name)
#     {:reply, result, state}
#   end
#
#   def handle_call({room}, _from, state) do
#     %{ets_table_name: ets_table_name} = state
#     result = :ets.lookup(ets_table_name, room)
#     {:reply, result, state}
#   end
#
#   def handle_call(_msg, _from, state) do
#     {:reply, :ok, state}
#   end
#
#   def handle_cast(_msg, state) do
#     {:reply, state}
#   end
#
#   def handle_info(_msg, state) do
#     {:noreply, state}
#   end
#
#   def terminate(_reason, _state) do
#     :ok
#   end
#
#   def code_change(_old_version, state, _extra) do
#     {:ok, state}
#   end
#
#   def log_message(channel, message) do
#     GenServer.call(:chat_log, {channel, message})
#   end
#
#   defp log_message(channel, message, ets_table_name) do
#     case :ets.member(ets_table_name, channel) do
#       false ->
#         true = :ets.insert(ets_table_name, {channel, [message]})
#         {:ok, message}
#       true ->
#          [{_channel, messages}]= :ets.lookup(ets_table_name, channel)
#          :ets.insert(ets_table_name, {channel, [message | messages]})
#         {:ok, message}
#     end
#   end
#
#
#   # Client
#
#   def start_link(default) do
#     GenServer.start_link(__MODULE__, default)
#   end
#
#   def step(pid, mac, ip, order) do
#     GenServer.cast(pid, {:step, mac, ip, order})
#   end
#
#   def done(pid, mac, ip) do
#     GenServer.cast(pid, {:done, mac, ip})
#   end
#
#   #
#   # def pop(pid) do
#   #   GenServer.call(pid, :pop)
#   # end
#
#   # iex(3)> expenses = %{groceries: 200, rent: 1000, commute: 70}
#   # %{commute: 70, groceries: 200, rent: 1000}
#   # iex(4)> Map.put(expenses, :booze, 100)
#   # %{booze: 100, commute: 70, groceries: 200, rent: 1000}
#   # iex(5)> Map.put(expenses, "frank", 200)
#   # %{:commute => 70, :groceries => 200, :rent => 1000, "frank" => 200}
#   #
#   # Server (callbacks)
#
#   # def handle_call(:pop, _from, [h | t]) do
#   #   {:reply, h, t}
#   # end
#   #
#   # def handle_call(request, from, state) do
#   #   # Call the default implementation from GenServer
#   #   super(request, from, state)
#   # end
#
#   def handle_cast({:step, mac, ip, order}, state) do
#     {:noreply, Map.put(state, mac, %{ip: ip, status: "wip", step: order})}
#   end
#
#   def handle_cast({:stop, mac, ip}, state) do
#     {:noreply, Map.put(state, mac, %{ip: ip, status: "done", step: nil})}
#   end
#
#   # def handle_cast(request, state) do
#   #   super(request, state)
#   # end
# end
