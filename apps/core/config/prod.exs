use Mix.Config

config :core, CoreWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  debug_errors: false,
  code_reloader: false

config :logger, level: :info
