use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :attestation_api, AttestationApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "attestation_api_dev",
  hostname: "localhost",
  port: "5432",
  pool_size: 10

config :attestation_api, AttestationApi.Clients.Veriffme,
  api_url: {:system, "VERIFFME_API_URL", "https://api.veriff.me/v1"},
  auth_client: {:system, "VERIFFME_AUTH_CLIENT"},
  api_secret: {:system, "VERIFFME_API_SECRET"}

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
