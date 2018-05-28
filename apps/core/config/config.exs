use Mix.Config

config :core, :kimlic_website, url: {:system, "KIMLIC_WEBSITE_URL", ""}

config :core, :emails,
  create_profile_email: %{
    from_email: {:system, "EMAIL_CREATE_PROFILE_FROM_EMAIL", "support@kimlic.com"},
    from_name: {:system, "EMAIL_CREATE_PROFILE_FROM_NAME", "Kimlic"},
    subject: {:system, "EMAIL_CREATE_PROFILE_SUBJECT", "Profile registration"}
  }

import_config "#{Mix.env()}.exs"
