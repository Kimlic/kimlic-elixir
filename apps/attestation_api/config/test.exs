use Mix.Config

config :attestation_api, AttestationApi.Endpoint,
  http: [port: 4001],
  server: false

config :attestation_api, :dependencies,
  veriffme: VeriffmeMock,
  push: PushMock

config :attestation_api, AttestationApi.Repo,
  url: "postgres://postgres:postgres@localhost:5432/attestation_api_test",
  pool: Ecto.Adapters.SQL.Sandbox

# for tests only
config :attestation_api, kimlic_vendor_id: "87177897-2441-43af-a6bf-4860afcdd067"

config :logger, level: :warn
