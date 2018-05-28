# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :proxy_api,
  namespace: ProxyApi

# Configures the endpoint
config :proxy_api, ProxyApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K6HcbKqaTy7SKd3wkLPFuiaBN4xy0lXT7Z4er1HpDS9uKkmqGmeTzOQMuj+DTLar",
  render_errors: [view: ProxyApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: ProxyApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
