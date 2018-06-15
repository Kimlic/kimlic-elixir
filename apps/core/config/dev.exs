use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :core, Redix,
  host: "127.0.0.1",
  port: 6379

config :ex_twilio,
  account_sid: "${TWILIO_ACCOUNT_SID}",
  auth_token: "${TWILIO_AUTH_TOKEN}"

config :core, Core.Clients.Veriffme,
  api_url: {:system, "VERIFFME_API_URL", "https://api.veriff.me/v1"},
  auth_client: {:system, "VERIFFME_AUTH_CLIENT"},
  api_secret: {:system, "VERIFFME_API_SECRET"}

config :core, Core.Clients.Mailer, adapter: Swoosh.Adapters.Local
