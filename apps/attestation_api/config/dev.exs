use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :attestation_api, AttestationApi.Repo,
  url: "postgres://postgres:postgres@localhost:5432/attestation_api_dev",
  pool_size: 10

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
