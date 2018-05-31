defmodule Core.Email.Views.CreateProfileEmail do
  @moduledoc false

  import Swoosh.Email

  require EEx

  @spec mail(binary, binary) :: Swoosh.Email.t()
  def mail(email, code) do
    email_data = Confex.fetch_env!(:core, :emails)[:create_profile_email]
    mail_html = EEx.eval_file(mail_path(), code: code)

    new()
    |> to(email)
    |> from({email_data.from_name, email_data.from_email})
    |> subject(email_data.subject)
    |> html_body(mail_html)
  end

  @spec mail_path :: binary
  defp mail_path, do: __DIR__ <> "/../templates/create_profile_email.html.eex"
end
