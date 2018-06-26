use Mix.Config

config :fido_qr_code,
  fido_server_url: "${FIDO_SERVER_URL}",
  ecto_repos: [FidoQrCode.Repo]

import_config "#{Mix.env()}.exs"
