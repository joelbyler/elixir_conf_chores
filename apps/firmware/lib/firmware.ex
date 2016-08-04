defmodule Firmware do
  use Application

  alias Nerves.Networking

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    migrate
    seed
    setup_network

    # Define workers and child supervisors to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, CaptivePortalLoginRedirector, [], port: 4000)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp migrate do
    {:ok, _} = Application.ensure_all_started(:user_interface)

    path = Application.app_dir(:user_interface, "priv/repo/migrations")

    Ecto.Migrator.run(UserInterface.Repo, path, :up, all: true)
  end

  defp seed do
    alias UserInterface.Repo
    alias UserInterface.Chore

    Repo.insert! %Chore{
      name: "Attend Joel's Talk",
      order: 1,
      description: "I think you'll enjoy it.",
      bonus: false
    }

    Repo.insert! %Chore{
      name: "Tweet at Joel and/or ElixirConf",
      order: 2,
      description: "His twittler account is @joelbyler",
      bonus: true
    }

    Repo.insert! %Chore{
      name: "Complement your neighbor",
      order: 3,
      description: "Its good to make friends",
      bonus: false
    }
  end

  defp setup_network do

    IO.puts "Setting sysctl"
    System.cmd("sysctl", ["-w", "net.ipv4.ip_forward=1"]) |> print_cmd_result

    IO.puts "Initializing eth0"
    Networking.setup(:eth0)

    System.cmd("ip", ["link", "set", "eth0", "up"]) |> print_cmd_result
    System.cmd("ip", ["addr", "add", "192.168.1.6/24", "dev", "eth0"]) |> print_cmd_result
    System.cmd("ip", ["route", "add", "default", "via", "192.168.1.1"]) |> print_cmd_result

    IO.puts "Initializing wlan0"
    System.cmd("ip", ["link", "set", "wlan0", "up"]) |> print_cmd_result
    System.cmd("ip", ["addr", "add", "192.168.24.1/24", "dev", "wlan0"]) |> print_cmd_result

    IO.puts "Initializing dnsmasq"
    System.cmd("dnsmasq", ["--dhcp-lease", "/root/dnsmasq.lease"]) |> print_cmd_result

    IO.puts "Initializing system"
    System.cmd("hostapd", ["-B", "-d", "/etc/hostapd/hostapd.conf"]) |> print_cmd_result

    IO.puts "Initializing iptables"
    System.cmd("setup_iptables", []) |> print_cmd_result
  end

  defp print_cmd_result({message, 0}) do
    IO.puts message
  end

  defp print_cmd_result({message, err_no}) do
    IO.puts "ERROR (#{err_no}): #{message}"
  end

end
