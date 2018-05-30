use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :core, Redix,
  host: "127.0.0.1",
  port: 6379

config :core, Core.Clients.Mailer, adapter: Swoosh.Adapters.Local
