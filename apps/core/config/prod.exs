use Mix.Config

config :core, CoreWeb.Endpoint,
  load_from_system_env: true,
  url: [
    host: "localhost",
    port: 4000
  ],
  debug_errors: false,
  code_reloader: false

config :logger, level: :info
