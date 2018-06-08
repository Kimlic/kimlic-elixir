defmodule Core.Auth do
  @moduledoc false

  import Core.Verifications.Verification, only: [allowed_type_atom: 1]

  alias Core.Email
  alias Core.Verifications
  alias Core.Verifications.Verification

  @messenger Application.get_env(:core, :dependencies)[:messenger]

  @spec create_email_verification(binary, binary) :: :ok | {:error, binary}
  def create_email_verification(email, account_address) do
    with {:ok, verification} <- Verifications.create_verification(account_address, :email),
         :ok <- create_verification_contract(account_address, :email) do
      Email.send_verification(email, verification)
    end
  end

  @spec create_phone_verification(binary, binary) :: :ok | {:error, binary}
  def create_phone_verification(phone, account_address) do
    with {:ok, %Verification{token: sms_code}} <- Verifications.create_verification(account_address, :phone),
         :ok <- create_verification_contract(account_address, :phone),
         # todo: move message to resources
         {:ok, %{}} <- @messenger.send(phone, "Here is your code: #{sms_code}") do
      :ok
    end
  end

  @spec create_verification_contract(binary, atom) :: :ok
  defp create_verification_contract(account_address, type) do
    Quorum.create_verification_contract(
      account_address,
      type,
      {Verifications, :update_verification_contract_address, [account_address, type]}
    )
  end

  @spec verify(atom, binary, binary) :: :ok | {:error, term}
  def verify(verification_type, account_address, token) when allowed_type_atom(verification_type),
    do: do_verify(verification_type, account_address, token)

  @spec verify(:phone | :email, binary, binary) :: :ok | {:error, term}
  defp do_verify(type, account_address, token) do
    with {:ok, %Verification{contract_address: contract_address} = verification} <-
           Verifications.get(account_address, type),
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
end
