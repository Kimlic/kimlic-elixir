use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :core, Redix, "${REDIS_URI}"

config :core, Core.Foundation.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "${AMAZON_SES_REGION_ENDPOINT}",
  access_key: "${AMAZON_SES_ACCESS_KEY}",
  secret: "${AMAZON_SES_SECRET_KEY}"
