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

  @spec check_verification(:phone | :email, binary) :: :ok | {:error, term}
  def check_verification(:email, token) do
    with :ok <- do_check_verification(:email, token) do
      # todo: call quorum
      :ok
    end
  end

  def check_verification(:phone, code) do
    with :ok <- do_check_verification(:phone, code) do
      # todo: call quorum
      :ok
    end
  end

  @spec check_verification(:phone | :email, binary) :: :ok | {:error, term}
  defp do_check_verification(type, token) do
    with {:ok, verification} <- Verifications.get(token, type),
         {:ok, 1} <- Verifications.delete(verification) do
      :ok
    else
      error -> error
    end
  end
end
