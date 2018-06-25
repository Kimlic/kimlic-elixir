use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  load_from_system_env: true,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :attestation_api, AttestationApi.Repo, url: "${POSTGRES_URI}"

config :logger, level: :info
