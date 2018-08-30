use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

# config :core, Redix, "${REDIS_URI}"
config :core, Redix, "redis://seLjCUSJ72naqfwYQvBg1jbORvjtsRKVnAY6RrAUEmA=@kimcore.redis.cache.windows.net:6379/1"

config :core, Core.Clients.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "${AMAZON_SES_REGION_ENDPOINT}",
  access_key: "${AMAZON_SES_ACCESS_KEY}",
  secret: "${AMAZON_SES_SECRET_KEY}"

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://kimlic:v2re3X7tMP@51.140.244.242:5672?heartbeat=30"
      # connect_options: [
      #   host: "${RABBITMQ_HOST}",
      #   username: "${RABBITMQ_USERNAME}",
      #   password: "${RABBITMQ_PASSWORD}"
      # ]
    ]
  ]

config :pigeon, :apns,
  apns_default: %{
    cert: "${PIGEON_APNS_CERT}",
    key: "${PIGEON_APNS_CERT_UNENCRYPTED}",
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
