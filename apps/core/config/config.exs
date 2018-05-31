use Mix.Config

config :core, :dependencies, token_generator: Core.Verifications.TokenGenerator

config :core, verification_email_ttl: {:system, "VERIFICATION_EMAIL_TTL", :timer.hours(24)}
config :core, verification_phone_ttl: {:system, "VERIFICATION_PHONE_TTL", :timer.hours(24)}

config :core, :emails,
  create_profile_email: %{
    from_email: {:system, "EMAIL_CREATE_PROFILE_FROM_EMAIL", "verification@kimlic.com"},
    from_name: {:system, "EMAIL_CREATE_PROFILE_FROM_NAME", "Kimlic"},
    subject: {:system, "EMAIL_CREATE_PROFILE_SUBJECT", "Kimlic - New user email verification"}
  }

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
