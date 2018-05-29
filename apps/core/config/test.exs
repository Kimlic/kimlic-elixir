use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :core, Redix, "redis://localhost:6379/1"

config :core, Core.Clients.Mailer, adapter: Swoosh.Adapters.Test
