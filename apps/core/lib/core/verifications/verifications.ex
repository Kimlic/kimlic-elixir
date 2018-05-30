defmodule Core.Verifications do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.StorageKeys
  alias Core.Verifications.Verification
  alias Ecto.Changeset

  @token_generator Application.get_env(:core, :dependencies)[:token_generator]
  @verification_status_new Verification.status(:new)

  @spec create_email_verification(binary, binary) :: {:ok, binary} | {:error, binary} | {:error, Ecto.Changeset.t()}
  def create_email_verification(email, account_address) do
    verification_ttl = Confex.fetch_env!(:core, :verification_email_ttl)
    token = @token_generator.generate_email_token(email, account_address)

    with %Ecto.Changeset{valid?: true} = verification <-
           create_verification(account_address, Verification.entity_type(:email), token),
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
    |> do_get()
  end

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(token, :phone) do
    token
    |> StorageKeys.vefirication_phone()
    |> do_get()
  end

  @spec do_get(binary) :: {:ok, %Verification{}} | {:error, term}
  defp do_get(redis_key) do
    redis_key
    |> Redis.get()
    |> case do
      {:ok, %Verification{} = verification} -> {:ok, verification}
      error -> {:error, :not_found}
    end
  end

  @spec delete(%Verification{}) :: :ok | {:error, term}
  def delete(%Verification{entity_type: type, token: token} = verification) do
    cond do
      type === Verification.entity_type(:email) -> StorageKeys.vefirication_email(token)
      type === Verification.entity_type(:phone) -> StorageKeys.vefirication_phone(token)
    end
    |> Redis.delete()
  end
end
