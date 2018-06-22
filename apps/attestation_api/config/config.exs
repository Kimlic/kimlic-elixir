use Mix.Config

config :attestation_api, namespace: AttestationApi

config :attestation_api, AttestationApi.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost"],
  secret_key_base: "84kntMYOcyFTBn7bL0ydvotZ4gDT1nPjwseG+VfCValy9GES2pgI2ir1FQemS/lz",
  render_errors: [view: AttestationApi.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

import_config "#{Mix.env()}.exs"
