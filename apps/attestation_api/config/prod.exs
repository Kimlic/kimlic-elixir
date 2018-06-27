use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  load_from_system_env: true,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :attestation_api, AttestationApi.Repo, url: "${POSTGRES_URI}"

config :attestation_api, AttestationApi.Clients.Veriffme,
  api_url: "${VERIFFME_API_URL}",
  auth_client: "${VERIFFME_AUTH_CLIENT}",
  api_secret: "${VERIFFME_API_SECRET}"

config :logger, level: :info
