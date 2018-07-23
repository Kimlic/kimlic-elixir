use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :core, Redix, "${REDIS_URI}"

config :core, Core.Clients.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "${AMAZON_SES_REGION_ENDPOINT}",
  access_key: "${AMAZON_SES_ACCESS_KEY}",
  secret: "${AMAZON_SES_SECRET_KEY}"

config :pigeon, :apns,
  apns_default: %{
    key: "${PIGEON_APNS_KEY}",
    key_identifier: "${PIGEON_APNS_KEY_IDENTIFIER}",
    team_id: "${PIGEON_APNS_TEAM_ID}",
    mode: :prod
  }

config :pigeon, :fcm,
  fcm_default: %{
    key: "${PIGEON_FCM_KEY}",
    mode: :prod
  }

config :ex_twilio,
  account_sid: "${TWILIO_ACCOUNT_SID}",
  auth_token: "${TWILIO_AUTH_TOKEN}"
