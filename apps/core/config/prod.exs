use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :core, Redix,
  host: {:system, "REDIS_HOST"},
  port: {:system, "REDIS_PORT"}

config :core, Core.Clients.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: {:system, "AMAZON_SES_REGION_ENDPOINT"},
  access_key: {:system, "AMAZON_SES_ACCESS_KEY"},
  secret: {:system, "AMAZON_SES_SECRET_KEY"}
