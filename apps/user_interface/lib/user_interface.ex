defmodule UserInterface do
  use Application
  alias ChoreRepository

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    ChoreRepository.setup
    ChoreRepository.seed

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(UserInterface.Endpoint, []),

      worker(UserInterface.ConnectionTracker, [[name: :connection_tracker]]),
      supervisor(UserInterface.Presence, []),

      # Start your own worker by calling: UserInterface.Worker.start_link(arg1, arg2, arg3)
      # worker(UserInterface.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UserInterface.Endpoint.config_change(changed, removed)
    :ok
  end
end
