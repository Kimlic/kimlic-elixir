use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :core, Redix,
  host: "127.0.0.1",
  port: 6379,
  database: 1

config :core, Core.Clients.Mailer, adapter: Swoosh.Adapters.Test
