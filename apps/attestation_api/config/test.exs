use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  http: [port: 4001],
  server: false

config :attestation_api, AttestationApi.Repo, url: "postgres://postgres:postgres@localhost:5432/attestation_api_test"

config :logger, level: :warn