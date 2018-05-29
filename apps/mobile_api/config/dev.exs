use Mix.Config

config :mobile_api, MobileApi.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
