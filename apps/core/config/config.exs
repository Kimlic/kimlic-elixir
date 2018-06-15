use Mix.Config

config :core, :dependencies,
  token_generator: Core.Verifications.TokenGenerator,
  messenger: Core.Clients.Messenger,
  veriffme: Core.Clients.Veriffme

config :core,
  verifications_ttl: [
    email: {:system, :integer, "VERIFICATION_EMAIL_TTL", :timer.hours(24)},
    phone: {:system, :integer, "VERIFICATION_PHONE_TTL", :timer.hours(24)},
    digital: {:system, :integer, "VERIFICATION_DIGITAL_TTL", :timer.hours(24)}
  ]

config :core, messenger_message_from: {:system, "MESSAGER_MESSAGE_FROM", "Kimlic"}

config :core, :emails,
  create_profile_email: %{
    from_email: {:system, "EMAIL_CREATE_PROFILE_FROM_EMAIL", "verification@kimlic.com"},
    from_name: {:system, "EMAIL_CREATE_PROFILE_FROM_NAME", "Kimlic"},
    subject: {:system, "EMAIL_CREATE_PROFILE_SUBJECT", "Kimlic - New user email verification"}
  }

config :core, Core.Clients.Veriffme,
  api_url: {:system, "VERIFFME_API_URL"},
  auth_client: {:system, "VERIFFME_AUTH_CLIENT"},
  api_secret: {:system, "VERIFFME_API_SECRET"}

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
