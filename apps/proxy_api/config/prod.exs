use Mix.Config

config :proxy_api, ProxyApi.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PROXY_API_PORT", "80"}],
  url: [
    host: {:system, "PROXY_API_HOST", "localhost"},
    port: {:system, "PROXY_API_PORT", "80"}
  ],
  secret_key_base: {:system, "PROXY_API_SECRET_KEY"},
  debug_errors: false,
  code_reloader: false

config :logger, level: :info

config :phoenix, :serve_endpoints, true
