defmodule Core.Verifications do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.StorageKeys
  alias Core.Verifications.Verification
  alias Ecto.Changeset

  @typep create_verification_t :: {:ok, %Verification{}} | {:error, binary} | {:error, Ecto.Changeset.t()}

  @token_generator Application.get_env(:core, :dependencies)[:token_generator]
  @verification_status_new Verification.status(:new)

  @verification_entity_type_email Verification.entity_type(:email)
  @verification_entity_type_phone Verification.entity_type(:phone)

  @spec create_email_verification(binary) :: create_verification_t
  def create_email_verification(account_address) do
    verification_ttl = Confex.fetch_env!(:core, :verification_email_ttl)
    token = @token_generator.generate(:email)

    create_verification(account_address, @verification_entity_type_email, token, verification_ttl)
  end

  @spec create_phone_verification(binary) :: create_verification_t
  def create_phone_verification(account_address) do
    verification_ttl = Confex.fetch_env!(:core, :verification_phone_ttl)
    token = @token_generator.generate(:phone)

    create_verification(account_address, @verification_entity_type_phone, token, verification_ttl)
  end

  @spec create_verification(binary, binary, integer, binary) :: create_verification_t
  defp create_verification(account_address, entity_type, token, verification_ttl) do
    with %Ecto.Changeset{valid?: true} = verification <- changeset(account_address, entity_type, token) do
      Redis.insert(verification, verification_ttl)
    end
  end

  @spec changeset(binary, binary, binary) :: Ecto.Changeset.t()
  defp changeset(account_address, entity_type, token) do
    Verification.changeset(%{
      account_address: account_address,
      entity_type: entity_type,
      token: token,
      status: @verification_status_new
    })
  end

  ### Quering

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(account_address, :email) do
    account_address
    |> StorageKeys.vefirication_email()
    |> Redis.get()
  end

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(account_address, :phone) do
    account_address
    |> StorageKeys.vefirication_phone()
    |> Redis.get()
  end

  @spec delete(%Verification{} | term) :: {:ok, non_neg_integer} | {:error, term}
  def delete(%Verification{entity_type: type, account_address: account_address})
      when type in [@verification_entity_type_email, @verification_entity_type_phone] do
    type
    |> case do
      @verification_entity_type_email -> StorageKeys.vefirication_email(account_address)
      @verification_entity_type_phone -> StorageKeys.vefirication_phone(account_address)
    end
    |> Redis.delete()
  end

  def delete(_) do
    {:error, :invalid_verification_type}
  end
end
