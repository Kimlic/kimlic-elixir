defmodule Core.Business.Auth.Mails.CreateProfileEmail do
  @moduledoc false

  import Swoosh.Email

  def mail(email, code) do
    # todo[ask]: email details

    new()
    |> to(email)
    |> from({"From Contact", "support@kimlic.com"})
    |> subject("Subject Here!")
    |> html_body("Follow next link: <a>#{code}</a>")
  end
end
