use Mix.Config

config :fido_qr_code, FidoQrCode.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "fido_qr_code_dev",
  hostname: "localhost"
