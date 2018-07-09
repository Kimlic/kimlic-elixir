defmodule Core.Integration.VerificationsTest do
  @moduledoc false

  use ExUnit.Case

  import Core.Factory
  import Mox

  alias Core.Clients.Redis
  alias Core.Verifications
  alias Quorum.Contract
  alias Quorum.Contract.Context
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  setup :set_mox_global

  @doc """
  Test written for manual testing.
  Before running you should change in Quorum config/test.exs :quorum, :client
  from QuorumClientMock to Ethereumex.HttpClient:

  change
    :quorum, :client: QuorumClientMock,
  to
    :quorum, :client: Ethereumex.HttpClient,

  and enable RabbitMQ workers for TaskBunny by removing [worker: false]:

  change
    [name: "transaction", jobs: [TransactionCreate], worker: false],
    [name: "transaction-status", jobs: [TransactionStatus], worker: false]
  to
    [name: "transaction", jobs: [TransactionCreate]],
    [name: "transaction-status", jobs: [TransactionStatus]]
  """
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

    assert {:error, :account_field_not_set} = Verifications.create_email_verification(email, account_address)
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

  defp assert_contract_verified(contract_address, sleep \\ 50) do
    :timer.sleep(sleep)

    data = Contract.hash_data(:base_verification, "status", [{}])

    case QuorumHttpClient.eth_call(%{to: contract_address, data: data}, "latest", []) do
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000001"} ->
        :ok

      _ ->
        case sleep do
          350 -> flunk("Verification Contract not verified. See Quorum.set_verification_result_transaction")
          _ -> assert_contract_verified(contract_address, sleep + 50)
        end
    end
  end

  defp init_quorum_user(doc_type) do
    assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    transaction_data = %{
      from: account_address,
      to: Context.get_account_storage_adapter_address(),
      data:
        Contract.hash_data(:account_storage_adapter, "setAccountFieldMainData", [
          {"#{:rand.uniform()}", doc_type}
        ]),
      gas: "0x500000",
      gasPrice: "0x0"
    }

    {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(transaction_data, [])
    :timer.sleep(150)

    {:ok, %{"status" => "0x1"}} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    :timer.sleep(150)

    account_address
  end
end
