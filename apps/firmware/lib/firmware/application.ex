defmodule Firmware.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, CaptivePortalLoginRedirector, [], port: 80),
    ]

    IO.puts "***** starting chores_net! *****"
    setup_network()

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init_kernel_modules() do
    {_, 0} = System.cmd("modprobe", [@kernel_module])
  end

  defp setup_network do
    :timer.sleep(5000)

    IO.puts "calling sysctl"
    System.cmd("sysctl", ["-w", "net.ipv4.ip_forward=1"]) |> print_cmd_result

    # unless disable_eth0? do
    #   Networking.setup(:eth0)
    #   System.cmd("ip", ["link", "set", "eth0", "up"]) |> print_cmd_result
    #   System.cmd("ip", ["addr", "add", "#{static_addr}/24", "dev", "eth0"]) |> print_cmd_result
    # end

    # IO.puts "adding default route"
    # System.cmd("ip", ["route", "add", "default", "via", default_gateway]) |> print_cmd_result

    IO.puts "setting link wlan0 up"
    System.cmd("ip", ["link", "set", "wlan0", "up"]) |> print_cmd_result

    IO.puts "adding addr"
    System.cmd("ip", ["addr", "add", "192.168.24.1/24", "dev", "wlan0"]) |> print_cmd_result

    IO.puts "starting dnsmasq"
    System.cmd("dnsmasq", ["--dhcp-lease", "/root/dnsmasq.lease"]) |> print_cmd_result

    IO.puts "starting hostapd"
    System.cmd("hostapd", ["-B", "-d", "/etc/hostapd/hostapd.conf"]) |> print_cmd_result

    # IO.puts "setting up iptables"
    # System.cmd("setup_iptables", []) |> print_cmd_result
  end

  defp print_cmd_result({message, 0}) do
    IO.puts message
  end

  defp print_cmd_result({message, err_no}) do
    IO.puts "ERROR (#{err_no}): #{message}"
  end

  defp disable_eth0? do
    Application.get_env(:firmware, :settings)[:disable_eth0]
  end

  defp default_gateway do
    Application.get_env(:firmware, :settings)[:default_gateway]
  end

  defp static_addr do
    Application.get_env(:firmware, :settings)[:static_addr]
  end
end
