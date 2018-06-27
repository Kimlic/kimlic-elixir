use Mix.Config

config :mobile_api, MobileApi.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "MOBILE_API_PORT", "80"}],
  url: [
    host: {:system, "MOBILE_API_HOST", "localhost"},
    port: {:system, "MOBILE_API_PORT", "80"}
  ],
  secret_key_base: {:system, "MOBILE_API_SECRET_KEY"},
  debug_errors: false,
  code_reloader: false

config :logger, level: :info

config :hammer,
  backend: {Hammer.Backend.Redis, [expiry_ms: :timer.hours(24) * 7, redix_config: "${REDIS_URI}"]}

config :phoenix, :serve_endpoints, true
