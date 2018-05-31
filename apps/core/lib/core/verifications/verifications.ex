defmodule Core.Verifications do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.StorageKeys
  alias Core.Verifications.Verification
  alias Ecto.Changeset

  @token_generator Application.get_env(:core, :dependencies)[:token_generator]
  @verification_status_new Verification.status(:new)

  @verification_entity_type_email Verification.entity_type(:email)
  @verification_entity_type_phone Verification.entity_type(:phone)

  @spec create_email_verification(binary) :: {:ok, binary} | {:error, binary} | {:error, Ecto.Changeset.t()}
  def create_email_verification(account_address) do
    verification_ttl = Confex.fetch_env!(:core, :verification_email_ttl)
    token = @token_generator.generate_code()

    with %Ecto.Changeset{valid?: true} = verification <-
           create_verification(account_address, @verification_entity_type_email, token),
         verification <- Changeset.apply_changes(verification),
         :ok <- Redis.set(StorageKeys.vefirication_email(token), verification, verification_ttl) do
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

  ### Quering

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(token, :email) do
    token
    |> StorageKeys.vefirication_email()
    |> Redis.get()
  end

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(token, :phone) do
    token
    |> StorageKeys.vefirication_phone()
    |> Redis.get()
  end

  @spec delete(%Verification{} | term) :: {:ok, non_neg_integer} | {:error, term}
  def delete(%Verification{entity_type: type, token: token})
      when type in [@verification_entity_type_email, @verification_entity_type_phone] do
    type
    |> case do
      @verification_entity_type_email -> StorageKeys.vefirication_email(token)
      @verification_entity_type_phone -> StorageKeys.vefirication_phone(token)
    end
    |> Redis.delete()
  end

  def delete(_) do
    {:error, :invalid_verification_type}
  end
end
