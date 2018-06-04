defmodule Core.Auth do
  @moduledoc false

  alias Core.Email
  alias Core.Verifications
  alias Core.Verifications.Verification

  @messenger Application.get_env(:core, :dependencies)[:messenger]

  @spec create_profile(binary, binary) :: :ok | {:error, binary}
  def create_profile(email, account_address) do
    with {:ok, verification} <- Verifications.create_email_verification(account_address) do
      Email.send_verification(email, verification)
    end
  end

  @spec create_phone_verification(binary, binary) :: :ok | {:error, binary}
  def create_phone_verification(phone, account_address) do
    # todo: call quorum: create verification contract
    with {:ok, %Verification{token: sms_code}} <- Verifications.create_phone_verification(account_address),
         # todo: move message to resources
         {:ok, %{}} <- @messenger.send(phone, "Here is your code: #{sms_code}") do
      :ok
    end
  end

  @spec check_verification(:phone | :email, binary, binary) :: :ok | {:error, term}
  def check_verification(:email, account_address, token) do
    with :ok <- do_check_verification(:email, account_address, token) do
      # todo: call quorum
      :ok
    end
  end

  def check_verification(:phone, account_address, code) do
    with :ok <- do_check_verification(:phone, account_address, code) do
      # todo: call quorum
      :ok
    end
  end

  @spec check_verification(:phone | :email, binary, binary) :: :ok | {:error, term}
  defp do_check_verification(type, account_address, token) do
    with {:ok, %Verification{} = verification} <- Verifications.get(account_address, type),
         {_, true} <- {:verification_access, can_access_verification?(verification, account_address, token)},
         {:ok, 1} <- Verifications.delete(verification) do
      :ok
    else
      {:verification_access, _} -> {:error, :not_found}
      error -> error
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
