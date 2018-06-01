use Mix.Config

config :core, :dependencies,
  token_generator: TokenGeneratorMock,
  messenger: Core.Clients.Messenger

config :core, Redix, "redis://localhost:6379/1"

config :core, Core.Clients.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn
