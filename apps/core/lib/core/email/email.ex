defmodule Core.Email do
  @moduledoc false

  alias Core.Clients.Mailer
  alias Core.Email.Templates.CreateProfileEmail
  alias Core.Verifications.Verification

  @spec send_verification(binary, %Verification{}) :: :ok | {:error, binary}
  def send_verification(email, %Verification{token: token}) do
    with {:ok, _} <- email |> CreateProfileEmail.mail(token) |> Mailer.deliver() do
      :ok
    end
  end
end
