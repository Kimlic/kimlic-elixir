defmodule Core.Email.Templates.CreateProfileEmail do
  @moduledoc false

  import Swoosh.Email

  @spec mail(binary, binary) :: Swoosh.Email.t()
  def mail(email, code) do
    email_data = Confex.fetch_env!(:core, :emails)[:create_profile_email]
    kimlic_website_url = Confex.fetch_env!(:core, :kimlic_website)[:url]

    new()
    |> to(email)
    |> from({email_data.from_name, email_data.from_email})
    |> subject(email_data.subject)
    |> html_body("Follow next link: <a href=\"#{kimlic_website_url}/activate-user/#{code}\">click</a>")
  end
end
