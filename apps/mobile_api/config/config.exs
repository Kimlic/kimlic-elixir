use Mix.Config

config :mobile_api, namespace: MobileApi

config :mobile_api, MobileApi.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost"],
  secret_key_base: "ghZOO+R91Vccb2LL2mwvwDIzuJ75zidmln2nZFpaCnyoRGxjX/q1K5/tzZ3nLn/b",
  render_errors: [view: MobileApi.ErrorView, accepts: ~w(json)]

config :mobile_api,
  rate_limit_create_phone_verification_timeout:
    {:system, :integer, "RATE_LIMIT_CREATE_PHONE_VERIFICATION_TIMEOUT", :timer.hours(24) * 7}

config :mobile_api,
  rate_limit_create_phone_verification_attempts: {:system, :integer, "RATE_LIMIT_CREATE_PHONE_VERIFICATION_ATTEMPTS", 5}

config :phoenix, :format_encoders, json: Jason

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
