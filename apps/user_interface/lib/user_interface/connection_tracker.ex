defmodule Connection do
  defstruct mac: "", ip: "", status: "", step: false
end

defmodule UserInterface.ConnectionTracker do
  use GenServer

  # Client API

  def start_link(opts \\ []) do
    initial_state = [
      ets_table_name: :connection_tracker,
      connections: %{}
    ]

    {:ok, pid} = GenServer.start_link(__MODULE__, initial_state, opts)
  end

  def step(mac, ip, step) do
    GenServer.cast(:connection_tracker, {:step, mac, ip, step})
    UserInterface.Endpoint.broadcast!("chore:lobby", "connection_update", %{})
  end

  def done(mac, ip) do
    GenServer.cast(:connection_tracker, {:done, mac, ip})
  end

  def remove(mac) do
    GenServer.cast(:connection_tracker, {:remove, mac})
  end

  def connections do
    GenServer.call(:connection_tracker, {:connections})
  end

  def connection(mac) do
    GenServer.call(:connection_tracker, {:connection, mac})
  end

  # Server implementation

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:connections, connections}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{connections: connections, ets_table_name: ets_table_name}}
  end

  def handle_cast({:step, mac, ip, step}, state) do
    true = :ets.insert(state.ets_table_name, {mac, %{ip: ip, status: "wip", step: step}})
    {:noreply, state }
  end

  def handle_cast({:done, mac, ip}, state) do
    true = :ets.insert(state.ets_table_name, {mac, %{ip: ip, status: "done", step: nil}})
    {:noreply, state}
  end

  def handle_cast({:remove, mac}, state) do
    true = :ets.delete(state.ets_table_name, mac)
    {:noreply, state}
  end

  def handle_call({:connections}, _from, state) do
    connections = :ets.match(state.ets_table_name, :"$1") |> Enum.map( fn(item) -> hd(item) end)

    {:reply, map_to_connection_list(connections), state}
  end

  def handle_call({:connection, mac}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, mac) |> hd |> map_to_connection
    {:reply, result, state}
  end

  def handle_call(msg, _from, state) do
    IO.puts "WARNING: default call in GenServer"
    {:reply, :ok, connections}
  end

  def handle_cast(_msg, state) do
    IO.puts "WARNING: default cast in GenServer"
    {:noreply, connections}
  end

  def stop(server) do
    GenServer.call(server, :stop)
  end

  defp map_to_connection_list(connections) do
    Enum.map(connections, fn(connection) ->
       map_to_connection(connection)
    end)
  end

  defp map_to_connection({mac, nil}) do
    %Connection{}
  end

  defp map_to_connection(connection) do
    struct(%Connection{ mac: hd(Tuple.to_list(connection))}, hd(tl(Tuple.to_list(connection))))
  end
end
