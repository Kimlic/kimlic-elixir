use Mix.Config

config :attestation_api, namespace: AttestationApi

config :attestation_api, AttestationApi.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost"],
  secret_key_base: "84kntMYOcyFTBn7bL0ydvotZ4gDT1nPjwseG+VfCValy9GES2pgI2ir1FQemS/lz",
  render_errors: [view: AttestationApi.ErrorView, accepts: ~w(json)]

config :attestation_api, ecto_repos: [AttestationApi.Repo]

config :attestation_api, :dependencies, veriffme: AttestationApi.Clients.Veriffme

config :attestation_api, AttestationApi.Clients.Veriffme,
  api_url: {:system, "VERIFFME_API_URL"},
  auth_client: {:system, "VERIFFME_AUTH_CLIENT"},
  api_secret: {:system, "VERIFFME_API_SECRET"}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

import_config "#{Mix.env()}.exs"
