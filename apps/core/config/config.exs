use Mix.Config

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
