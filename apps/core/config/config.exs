use Mix.Config

config :core, :kimlic_website, url: {:system, "KIMLIC_WEBSITE_URL", ""}

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
