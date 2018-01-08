# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

config :nerves, :firmware,
  rootfs_overlay: "config/rootfs_overlay"

# Use bootloader to start the main application. See the bootloader
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :bootloader,
  init: [:nerves_runtime],
  app: Mix.Project.config[:app]

config :nerves, :firmware,
  rootfs_overlay: "config/rootfs_overlay"

config :firmware, :settings,
  static_addr: "192.168.11.6",
  default_gateway: "192.168.11.1",
  disable_eth0: false

config :user_interface, UserInterface.Endpoint,
  http: [port: 8080],
  url: [host: "localhost", port: 8080],
  secret_key_base: "LOQ9556hzfXeJ75BJ35g2/oF6bXfyzr+6liQGaB53fJkSSuXjqw/ksdx7/ct+elw",
  root: Path.dirname(__DIR__),
  check_origin: false,
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: UserInterface.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :nerves_network, :default,
  wlan0: [ ipv4_address_method: :linklocal ]

config :logger, level: :debug

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
