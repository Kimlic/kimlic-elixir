defmodule Core.Verifications do
  @moduledoc false

  import Core.Verifications.Verification, only: [allowed_type_atom: 1]

  alias Core.Clients.Redis
  alias Core.Verifications.Verification
  alias Log

  @typep create_verification_t :: {:ok, %Verification{}} | {:error, binary} | {:error, Ecto.Changeset.t()}

  @token_generator Application.get_env(:core, :dependencies)[:token_generator]
  @verification_status_new Verification.status(:new)

  @spec verification_ttl(atom) :: pos_integer
  defp verification_ttl(:phone), do: Confex.fetch_env!(:core, :verifications_ttl)[:phone]
  defp verification_ttl(:email), do: Confex.fetch_env!(:core, :verifications_ttl)[:email]

  @spec create_verification(binary, atom) :: create_verification_t
  def create_verification(account_address, type) when allowed_type_atom(type) do
    %{
      account_address: account_address,
      token: @token_generator.generate(type),
      entity_type: Verification.entity_type(type),
      status: @verification_status_new
    }
    |> insert_verification(verification_ttl(type))
  end

  @spec insert_verification(map, binary) :: create_verification_t
  defp insert_verification(attrs, verification_ttl) do
    with %Ecto.Changeset{valid?: true} = verification <- Verification.changeset(attrs) do
      Redis.upsert(verification, verification_ttl)
    end
  end

  ### Callbacks (do not remove)

  @spec update_verification_contract_address(binary, binary, map, {:ok, binary} | {:error, binary}) :: :ok
  def update_verification_contract_address(
        account_address,
        verification_type,
        _transaction_status,
        {:ok, contract_address}
      ) do
    verification_type = String.to_atom(verification_type)

    with {:ok, verification} = get(account_address, verification_type),
         verification <- %Verification{verification | contract_address: contract_address},
         %Ecto.Changeset{valid?: true} = changeset <- verification |> Map.from_struct() |> Verification.changeset(),
         {:ok, _} <- Redis.upsert(changeset, verification_ttl(verification_type)) do
      :ok
    end
  end

  def update_verification_contract_address(_, _, _, {:error, reason}) do
    Log.error("[#{__MODULE__}]: fail to update verification contract address with info: #{inspect(reason)}")
  end

  ### Quering

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(account_address, type) do
    type
    |> Verification.entity_type()
    |> Verification.redis_key(account_address)
    |> Redis.get()
  end

  @spec delete(%Verification{} | term) :: {:ok, non_neg_integer} | {:error, term}
  def delete(%Verification{} = verification) do
    Redis.delete(verification)
  end
end
