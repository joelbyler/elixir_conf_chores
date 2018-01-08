# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :user_interface, UserInterface.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZRd1n/LY1LbGT4lUd+PRK1jLxxQFkoNGiWQDnzOpSaWkvImGmQhMylcjgPCUFrlj",
  render_errors: [view: UserInterface.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UserInterface.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :router_controls, system_client: System

config :chore_repository, :config,
  file: "/root/chore_repository"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
