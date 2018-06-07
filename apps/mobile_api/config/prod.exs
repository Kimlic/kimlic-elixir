use Mix.Config

config :mobile_api, MobileApi.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT", "80"}],
  url: [
    host: {:system, "HOST", "localhost"},
    port: {:system, "PORT", "80"}
  ],
  secret_key_base: {:system, "SECRET_KEY"},
  debug_errors: false,
  code_reloader: false

config :logger, level: :info

config :hammer, backend: {Hammer.Backend.Redis, [expiry_ms: :timer.hours(24) * 7, redix_config: "${REDIS_URI}"]}

config :phoenix, :serve_endpoints, true
