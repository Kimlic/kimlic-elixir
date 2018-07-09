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

config :attestation_api, AttestationApi.Clients.Veriffme,
  api_url: {:system, "VERIFFME_API_URL", "https://api.veriff.me/v1"},
  auth_client: {:system, "VERIFFME_AUTH_CLIENT"},
  api_secret: {:system, "VERIFFME_API_SECRET"}

config :pigeon, :apns,
  apns_default: %{
    key: "AuthKey.p8",
    key_identifier: "key_identifier",
    team_id: "team_id",
    mode: :dev
  }

config :pigeon, :fcm,
  fcm_default: %{
    key: "your_fcm_key_here",
    mode: :dev
  }

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
