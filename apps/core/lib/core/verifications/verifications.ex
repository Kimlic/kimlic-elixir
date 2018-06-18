defmodule Core.Verifications do
  @moduledoc false

  import Core.Verifications.Verification, only: [allowed_type_atom: 1]

  alias __MODULE__
  alias Core.Clients.Redis
  alias Core.ContractAddresses
  alias Core.Email
  alias Core.Verifications.Verification
  alias Log

  @typep create_verification_t :: {:ok, %Verification{}} | {:error, binary} | {:error, Ecto.Changeset.t()}

  @token_generator Application.get_env(:core, :dependencies)[:token_generator]
  @messenger Application.get_env(:core, :dependencies)[:messenger]

  ### Business

  @spec create_email_verification(binary, binary) :: :ok | {:error, binary}
  def create_email_verification(email, account_address) do
    with {:ok, verification} <- create_verification(account_address, :email),
         {:ok, contract_address} <- ContractAddresses.get("VerificationContractFactory"),
         :ok <- create_verification_contract(:email, account_address, contract_address) do
      Email.send_verification(email, verification)
    end
  end

  @spec create_phone_verification(binary, binary) :: :ok | {:error, binary}
  def create_phone_verification(phone, account_address) do
    with {:ok, %Verification{token: sms_code}} <- create_verification(account_address, :phone),
         {:ok, contract_address} = ContractAddresses.get("VerificationContractFactory"),
         :ok <- create_verification_contract(:phone, account_address, contract_address),
         # todo: move message to resources
         {:ok, %{}} <- @messenger.send(phone, "Here is your code: #{sms_code}") do
      :ok
    end
  end

  @spec create_verification(binary, atom) :: create_verification_t
  def create_verification(account_address, type) when allowed_type_atom(type) do
    %{
      account_address: account_address,
      token: @token_generator.generate(type),
      entity_type: Verification.entity_type(type),
      status: Verification.status(:new)
    }
    |> insert_verification(verification_ttl(type))
  end

  @spec create_verification_contract(atom, binary, binary) :: :ok
  defp create_verification_contract(type, account_address, contract_address) do
    Quorum.create_verification_contract(
      type,
      account_address,
      contract_address,
      {__MODULE__, :update_verification_contract_address, [account_address, type]}
    )
  end

  @spec verify(atom, binary, binary) :: :ok | {:error, term}
  def verify(verification_type, account_address, token) when allowed_type_atom(verification_type) do
    with {:ok, %Verification{contract_address: contract_address} = verification} <-
           Verifications.get(account_address, verification_type),
         {_, "0x" <> _} <- {:contract_address_set, contract_address},
         {_, true} <- {:verification_access, can_access_verification?(verification, account_address, token)},
         {:ok, 1} <- Verifications.delete(verification),
         :ok <- Quorum.set_verification_result_transaction(account_address, contract_address) do
      :ok
    else
      {:contract_address_set, _} -> {:error, :not_found}
      {:verification_access, _} -> {:error, :not_found}
      err -> err
    end
  end

  @spec can_access_verification?(%Verification{}, binary, binary) :: boolean
  defp can_access_verification?(
         %{token: token, account_address: account_address},
         request_account_address,
         request_token
       ) do
    account_address == request_account_address and token == request_token
  end

  @spec verification_ttl(atom) :: pos_integer
  defp verification_ttl(:phone), do: Confex.fetch_env!(:core, :verifications_ttl)[:phone]
  defp verification_ttl(:email), do: Confex.fetch_env!(:core, :verifications_ttl)[:email]

  ### Callbacks (do not remove)

  @spec update_verification_contract_address(binary, binary, map, {:ok, binary} | {:error, binary}) :: :ok
  def update_verification_contract_address(
        account_address,
        verification_type,
        _transaction_status,
        {:ok, contract_address}
      ) do
    verification_type = String.to_atom(verification_type)

    with {:ok, verification} = Verifications.get(account_address, verification_type),
         verification <- %Verification{verification | contract_address: contract_address},
         %Ecto.Changeset{valid?: true} = changeset <- verification |> Map.from_struct() |> Verification.changeset(),
         {:ok, _} <- Redis.upsert(changeset, verification_ttl(verification_type)) do
      :ok
    end
  end

  def update_verification_contract_address(_, _, _, {:error, reason}) do
    Log.error("[#{__MODULE__}]: fail to update verification contract address with info: #{inspect(reason)}")
  end

  ### CRUD

  @spec insert_verification(map, binary) :: create_verification_t
  defp insert_verification(attrs, verification_ttl) do
    with %Ecto.Changeset{valid?: true} = verification <- Verification.changeset(attrs) do
      Redis.upsert(verification, verification_ttl)
    end
  end

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(account_address, type) do
    redis_key =
      type
      |> Verification.entity_type()
      |> Verification.redis_key(account_address)

    redis_key
    |> Redis.get()
    |> case do
      {:ok, verification} -> {:ok, %Verification{verification | redis_key: redis_key}}
      err -> err
    end
  end

  @spec delete(%Verification{} | term) :: {:ok, non_neg_integer} | {:error, term}
  def delete(%Verification{} = verification), do: Redis.delete(verification)
end
