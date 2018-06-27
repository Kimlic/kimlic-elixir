use Mix.Config

config :public_api, PublicApi.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PUBLIC_API_PORT", "80"}],
  url: [
    host: {:system, "PUBLIC_API_HOST", "localhost"},
    port: {:system, "PUBLIC_API_PORT", "80"}
  ],
  secret_key_base: {:system, "PUBLIC_API_SECRET_KEY"},
  debug_errors: false,
  code_reloader: false

config :logger, level: :info

config :phoenix, :serve_endpoints, true
