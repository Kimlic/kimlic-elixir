use Mix.Config

config :mobile_api, MobileApi.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :hammer,
  backend: {Hammer.Backend.Redis, [expiry_ms: :timer.hours(24) * 7, redix_config: [host: "127.0.0.1", port: 6379]]}

config :phoenix, :stacktrace_depth, 20
