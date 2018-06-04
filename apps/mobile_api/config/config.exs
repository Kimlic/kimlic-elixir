use Mix.Config

config :mobile_api, namespace: MobileApi

config :mobile_api, MobileApi.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost"],
  secret_key_base: "ghZOO+R91Vccb2LL2mwvwDIzuJ75zidmln2nZFpaCnyoRGxjX/q1K5/tzZ3nLn/b",
  render_errors: [view: MobileApi.ErrorView, accepts: ~w(json)]

config :phoenix, :format_encoders, json: Jason

config :hammer,
  backend:
    {Hammer.Backend.Redis,
     [expiry_ms: :timer.hours(24), cleanup_interval_ms: :timer.minutes(1), redix_config: "${REDIS_HOST}"]}

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
