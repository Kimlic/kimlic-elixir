use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :core, Redix,
  host: "${REDIS_HOST}",
  port: "${REDIS_PORT}"

config :core, Core.Clients.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "${AMAZON_SES_REGION_ENDPOINT}",
  access_key: "${AMAZON_SES_ACCESS_KEY}",
  secret: "${AMAZON_SES_SECRET_KEY}"
