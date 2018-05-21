# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :core, namespace: Core

# Configures the endpoint
config :core, CoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZeDsIZouP3XioaO1vSNgRHA25zfJUGTsmyvvPS8QW6gYPeS/tFlzZPgABjcX6Ob7",
  render_errors: [view: CoreWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Core.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
