defmodule Firmware do
  use Application

  alias Nerves.Networking

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    unless :os.type == {:unix, :darwin} do     # don't start networking unless we're on nerves
      {:ok, _pid} = Networking.setup :eth0
    end

    migrate
    seed

    # Define workers and child supervisors to be supervised
    children = [
      # worker(Firmware.Worker, [arg1, arg2, arg3]),
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

end
