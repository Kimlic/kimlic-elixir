use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT", "80"}],
  url: [
    host: {:system, "HOST", "localhost"},
    port: {:system, "PORT", "80"}
  ],
  secret_key_base: {:system, "SECRET_KEY"},
  debug_errors: false,
  code_reloader: false

config :attestation_api, AttestationApi.Repo,
  username: "kimlic@kimcore-attestation",
  password: "LU6dME4NzQ",
  database: "ap_server",
  hostname: "kimcore-attestation.postgres.database.azure.com",
  port: "5432",
  pool_size: 10,
  timeout: 15_000,
  pool_timeout: 15_000,
  loggers: [{Ecto.LoggerJSON, :log, [:info]}]

config :attestation_api, AttestationApi.Clients.Veriffme,
  api_url: "${VERIFFME_API_URL}",
  auth_client: "${VERIFFME_AUTH_CLIENT}",
  api_secret: "${VERIFFME_API_SECRET}"

config :ecto_logger_json, truncate_params: true

config :logger, level: :info
