use Mix.Config

# General application configuration
config :core, namespace: Core

config :core,
  clients: [
    redis: Core.Foundation.Clients.Redis
  ]

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

import_config "#{Mix.env()}.exs"
