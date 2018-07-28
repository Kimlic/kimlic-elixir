defmodule Core.Integration.VerificationsTest do
  @moduledoc false

  use ExUnit.Case, async: false

  import Core.Factory
  import Mox

  alias Core.Clients.Redis
  alias Core.Verifications
  alias Quorum.Contract.Context

  @moduletag :integration

  @quorum_client Application.get_env(:quorum, :client)
  @account_storage_adapter Application.get_env(:quorum, :contracts)[:account_storage_adapter]
  @base_verification Application.get_env(:quorum, :contracts)[:base_verification]

  setup :set_mox_global

  @tag :pending
  test "create Email verification and verify email" do
    expect(MessengerMock, :send, fn _to, _message ->
      {:ok, %ExTwilio.Message{}}
    end)

    account_address = init_quorum_user("email")
    email = generate(:email)

    assert {:ok, verification} = Verifications.create_email_verification(email, account_address)
    refute verification.contract_address

    contract_address = assert_contract_address(verification.redis_key)

    assert :ok = Verifications.verify(:email, account_address, verification.token)

    assert {:error, :not_found} = Redis.get(verification.redis_key)

    assert_contract_verified(contract_address)
  end

  @tag :pending
  test "create Email verification when Account field email not set" do
    account_address = init_quorum_user("phone")
    email = "test@example.com"

    assert {:error, {:conflict, _}} = Verifications.create_email_verification(email, account_address)
  end

  @tag :pending
  test "create Phone verification and verify email" do
    phone = generate(:phone)

    expect(MessengerMock, :send, fn ^phone, _message -> {:ok, %{}} end)

    account_address = init_quorum_user("phone")
    assert {:ok, verification} = Verifications.create_phone_verification(phone, account_address)
    refute verification.contract_address

    contract_address = assert_contract_address(verification.redis_key)

    assert :ok = Verifications.verify(:phone, account_address, verification.token)

    assert {:error, :not_found} = Redis.get(verification.redis_key)

    assert_contract_verified(contract_address)
  end

  @spec assert_contract_address(binary, integer) :: binary | no_return
  defp assert_contract_address(redis_key, sleep \\ 50) do
    :timer.sleep(sleep)
    assert {:ok, verification} = Redis.get(redis_key)

    case verification.contract_address do
      nil ->
        case sleep do
          350 -> flunk("Contract address not set for verification. See callback from TransactionStatus worker")
          _ -> assert_contract_address(redis_key, sleep + 50)
        end

      contract_address ->
        contract_address
    end
  end

  @spec assert_contract_verified(binary, integer) :: :ok | no_return
  defp assert_contract_verified(contract_address, sleep \\ 50) do
    :timer.sleep(sleep)

    case @base_verification.get_status(to: contract_address) do
      # Verified status
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000002"} ->
        :ok

      _ ->
        case sleep do
          350 -> flunk("Verification Contract not verified. See Quorum.set_verification_result_transaction")
          _ -> assert_contract_verified(contract_address, sleep + 50)
        end
    end
  end

  @spec init_quorum_user(binary) :: binary
  defp init_quorum_user(doc_type) do
    assert {:ok, account_address} = @quorum_client.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = @quorum_client.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    {:ok, transaction_hash} =
      @account_storage_adapter.set_field_main_data_raw(
        to_string(:rand.uniform()),
        doc_type,
        from: account_address,
        to: Context.get_account_storage_adapter_address()
      )

    :timer.sleep(150)

    {:ok, %{"status" => "0x1"}} = @quorum_client.eth_get_transaction_receipt(transaction_hash, [])
    :timer.sleep(150)

    account_address
  end
end
