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
    # TODO: add this back in: UserInterface.Endpoint.broadcast!("chore:lobby", "connection_update", %{})
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

  def init([]) do
    connections = %{}
    {:ok, connections}
  end

  def handle_cast({:step, mac, ip, step}, connections) do
    {:noreply, Map.put(connections, mac, %{ip: ip, status: "wip", step: step}) }
  end

  def handle_cast({:done, mac, ip}, connections) do
    {:noreply, Map.put(connections, mac, %{ip: ip, status: "done", step: nil}) }
  end

  def handle_cast({:remove, mac}, connections) do
    {:noreply, Map.delete(connections, mac) }
  end

  def handle_call({:connections}, _from, connections) do
    {:reply, map_to_connection_list(connections), connections}
  end

  def handle_call({:connection, mac}, _from, connections) do
    {:reply, { mac, Map.get(connections, mac) } |> map_to_connection, connections}
  end

  def handle_call(msg, _from, connections) do
    IO.puts "WARNING: default call in GenServer"
    {:reply, :ok, connections}
  end

  def handle_cast(_msg, connections) do
    IO.puts "WARNING: default cast in GenServer"
    {:noreply, connections}
  end

  def stop(server) do
    GenServer.call(server, :stop)
  end

  defp map_to_connection_list(connections) do
    Enum.map(Map.to_list(connections), fn(connection) ->
       map_to_connection(connection)
    end)
  end

  defp map_to_connection({mac, nil}) do
    IO.puts("junk")
    %Connection{}
  end

  defp map_to_connection(connection) do
    struct(%Connection{ mac: hd(Tuple.to_list(connection))}, hd(tl(Tuple.to_list(connection))))
  end
end
