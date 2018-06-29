defmodule Core.Integration.VerificationsTest do
  use ExUnit.Case

  import Mox

  alias Core.Clients.Redis
  alias Core.Verifications
  alias Core.Verifications.TokenGenerator
  alias Ethereumex.HttpClient, as: QuorumHttpClient

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
    token = TokenGenerator.generate(:email)
    expect(TokenGeneratorMock, :generate, fn :email -> token end)

    assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    email = "test@example.com"

    assert {:ok, verification} = Verifications.create_email_verification(email, account_address)
    refute verification.contract_address

    contract_address = assert_contract_address(verification.redis_key)

    assert :ok = Verifications.verify(:email, account_address, verification.token)

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

    case QuorumHttpClient.eth_call(%{to: contract_address, data: "0x80007e83"}, "latest", []) do
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000001"} ->
        :ok

      _ ->
        case sleep do
          350 -> flunk("Verification Contract not verified. See Quorum.set_verification_result_transaction")
          _ -> assert_contract_address(contract_address, sleep + 50)
        end
    end
  end
end
