# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mobile_api,
  namespace: MobileApi

# Configures the endpoint
config :mobile_api, MobileApi.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost"],
  secret_key_base: "ghZOO+R91Vccb2LL2mwvwDIzuJ75zidmln2nZFpaCnyoRGxjX/q1K5/tzZ3nLn/b",
  render_errors: [view: MobileApi.ErrorView, accepts: ~w(json)]

# Configures loggers
config :phoenix, :format_encoders, json: Jason

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
