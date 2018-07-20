use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :core, Redix,
  host: "127.0.0.1",
  port: 6379

config :core,
  sync_fields: [
    "email",
    "phone",
    "documents.id_card",
    "documents.passport",
    "documents.driver_license",
    "documents.residence_permit_card"
  ]

config :ex_twilio,
  account_sid: "${TWILIO_ACCOUNT_SID}",
  auth_token: "${TWILIO_AUTH_TOKEN}"

config :core, Core.Clients.Mailer, adapter: Swoosh.Adapters.Local
