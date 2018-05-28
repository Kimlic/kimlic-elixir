defmodule Core.Auth do
  @moduledoc false

  alias Core.Email
  alias Core.Verifications

  @spec create_profile(binary, binary) :: :ok | {:error, binary}
  def create_profile(email, account_address) do
    with {:ok, verification} <- Verifications.create_email_verification(email, account_address),
         :ok <- Email.send_verification(email, verification) do
      :ok
    end
  end
end
