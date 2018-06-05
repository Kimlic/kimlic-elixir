use Mix.Config

config :mobile_api, MobileApi.Endpoint,
  http: [port: 4001],
  server: false

config :hammer,
  backend: {Hammer.Backend.Redis, [expiry_ms: :timer.hours(24) * 7, redix_config: "redis://localhost:6379/1"]}

config :logger, level: :warn
