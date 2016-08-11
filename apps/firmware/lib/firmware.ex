defmodule Firmware do
  use Application

  alias Nerves.Networking

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    setup_network

    # Define workers and child supervisors to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, CaptivePortalLoginRedirector, [], port: 80)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_network do
    RouterControls.IpForwarding.forward_ipv4
    Networking.setup(:eth0)
    RouterControls.Ethernet.start
    RouterControls.Wifi.start

    RouterControls.DnsMasq.start
    RouterControls.HostApd.start

    # TODO: RouterControls.IpTables.initalize
    System.cmd("setup_iptables", []) |> print_cmd_result
  end

  defp print_cmd_result({message, 0}) do
    IO.puts message
  end

  defp print_cmd_result({message, err_no}) do
    IO.puts "ERROR (#{err_no}): #{message}"
  end

end
