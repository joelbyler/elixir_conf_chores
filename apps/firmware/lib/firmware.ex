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
      Plug.Adapters.Cowboy.child_spec(:http, CaptivePortalLoginRedirector, [], port: 80),
      #supervisor(Phoenix.PubSub.PG2, [UserInterface.PubSub, [poolsize: 1]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_network do
    System.cmd("sysctl", ["-w", "net.ipv4.ip_forward=1"]) |> print_cmd_result

    # removing eth0 interface for demo
    # Networking.setup(:eth0)
    #
    # System.cmd("ip", ["link", "set", "eth0", "up"]) |> print_cmd_result
    # System.cmd("ip", ["addr", "add", "192.168.1.6/24", "dev", "eth0"]) |> print_cmd_result
    System.cmd("ip", ["route", "add", "default", "via", "192.168.24.1"]) |> print_cmd_result

    System.cmd("ip", ["link", "set", "wlan0", "up"]) |> print_cmd_result
    System.cmd("ip", ["addr", "add", "192.168.24.1/24", "dev", "wlan0"]) |> print_cmd_result

    System.cmd("dnsmasq", ["--dhcp-lease", "/root/dnsmasq.lease"]) |> print_cmd_result

    System.cmd("hostapd", ["-B", "-d", "/etc/hostapd/hostapd.conf"]) |> print_cmd_result

    System.cmd("setup_iptables", []) |> print_cmd_result
  end

  defp print_cmd_result({message, 0}) do
    IO.puts message
  end

  defp print_cmd_result({message, err_no}) do
    IO.puts "ERROR (#{err_no}): #{message}"
  end

end
