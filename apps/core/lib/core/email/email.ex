defmodule Core.Email do
  @moduledoc false

  alias Core.Clients.Mailer
  alias Core.Email.Views.CreateProfileEmail
  alias Core.Verifications.Verification

  @spec send_verification(binary, %Verification{}) :: :ok | {:error, binary}
  def send_verification(email, %Verification{token: token}) do
    email
    |> CreateProfileEmail.mail(token)
    |> Mailer.deliver()
    |> case do
      {:ok, _} ->
        :ok

      {:error, error_data} ->
        Log.error("[#{__MODULE__}] Fail to send email. Error: #{inspect(error_data)}")
        {:error, {:internal_error, "Fail to send email"}}
    end
  end
end
