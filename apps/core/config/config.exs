use Mix.Config

config :core, :dependencies, messenger: Core.Clients.Messenger

config :core,
  verifications_ttl: [
    email: {:system, :integer, "VERIFICATION_EMAIL_TTL", _day = 24 * 60 * 60},
    phone: {:system, :integer, "VERIFICATION_PHONE_TTL", _day = 24 * 60 * 60}
  ]

config :core, messenger_message_from: {:system, "MESSENGER_MESSAGE_FROM", "Kimlic"}

config :core, :emails,
  create_profile_email: %{
    from_email: {:system, "EMAIL_CREATE_PROFILE_FROM_EMAIL", "verification@kimlic.com"},
    from_name: {:system, "EMAIL_CREATE_PROFILE_FROM_NAME", "Kimlic"},
    subject: {:system, "EMAIL_CREATE_PROFILE_SUBJECT", "Kimlic - New user email verification"}
  }

config :core, sync_fields: {:system, :list, "SYNC_VERIFICATIONS"}

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
