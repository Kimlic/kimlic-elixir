defmodule Core.Verifications do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.Verifications.Verification
  alias Ecto.Changeset
  alias Ecto.UUID

  @verification_status_new Verification.status(:new)

  @spec create_email_verification(binary, binary) :: {:ok, binary} | {:error, binary} | {:error, Ecto.Changeset.t()}
  def create_email_verification(email, account_address) do
    token = :crypto.hash(:sha256, Enum.join([UUID.generate(), email, account_address]))

    with %Ecto.Changeset{valid?: true} = verification <-
           create_verification(account_address, Verification.entity_type(:email), token),
         verification <- Changeset.apply_changes(verification),
         :ok <- Redis.set("core.create_profile.email-vefirication.#{account_address}", verification, :timer.hours(24)) do
      {:ok, verification}
    end
  end

  @spec create_verification(binary, binary, binary) :: Ecto.Changeset.t()
  defp create_verification(account_address, entity_type, token, status \\ @verification_status_new) do
    Verification.changeset(%{
      account_address: account_address,
      entity_type: entity_type,
      token: token,
      status: status
    })
  end
end
