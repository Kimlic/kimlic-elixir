# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :public_api,
  namespace: PublicApi

# Configures the endpoint
config :public_api, PublicApi.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost"],
  secret_key_base: "lz9q5+6HvbQJ8twyC7pXB9aedy2hk4aVxeQ9QcLC+OQdZtT6/1dCtfCSrC4nPF8R",
  render_errors: [view: PublicApi.ErrorView, accepts: ~w(json)]

# Configures loggers
config :phoenix, :format_encoders, json: Jason

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"