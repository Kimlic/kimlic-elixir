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

config :attestation_api, AttestationApi.Repo, url: "${POSTGRES_URI}"

config :attestation_api, AttestationApi.Clients.Veriffme,
  api_url: "${VERIFFME_API_URL}",
  auth_client: "${VERIFFME_AUTH_CLIENT}",
  api_secret: "${VERIFFME_API_SECRET}"

config :pigeon, :apns,
  apns_default: %{
    key: "${PIGEON_APNS_KEY}",
    key_identifier: "${PIGEON_APNS_KEY_IDENTIFIER}",
    team_id: "${PIGEON_APNS_TEAM_ID}",
    mode: :prod
  }

config :pigeon, :fcm,
  fcm_default: %{
    key: "${PIGEON_FCM_KEY}",
    mode: :prod
  }

config :logger, level: :info
