defmodule Quorum.Unit.QuorumTest do
  use ExUnit.Case

  import Mox
  import Quorum.QueueTestHelper

  alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

  alias Ethereumex.HttpClient, as: QuorumHttpClient

  doctest Quorum

  setup :verify_on_exit!
  setup :set_mox_global

  @queue_create_user_account "kimlic-core-test.create-user-account"
  @queue_create_verification_contract "kimlic-core-test.create-verification-contract"
  @queue_update_user_account "kimlic-core-test.update-user-account"
  @queue_transaction_create "kimlic-core-test.transaction"
  @queue_transaction_status "kimlic-core-test.transaction-status"

  @tag :pending
  describe "create user account" do
    setup do
      on_exit(fn ->
        purge_all(@queue_create_user_account)
      end)
    end

    test "success" do
      quorum_client_resp = {:ok, "created"}
      expect(QuorumClientMock, :create_user_account, fn _params -> quorum_client_resp end)

      # Start job Create user account
      user_data = %{"transaction" => "create-user"}
      assert :ok == Quorum.create_user_account(user_data)

      # Ensure that queue contain message for user creation
      {payload, _queue_metadata} = pop(@queue_create_user_account)
      assert user_data == Jason.decode!(payload)["payload"]

      # manually invoke message processing
      assert quorum_client_resp == CreateUserAccount.perform(payload)
    end
  end

  @tag :pending
  describe "create verification contract" do
    setup do
      on_exit(fn ->
        purge_all(@queue_create_verification_contract)
      end)
    end

    test "success" do
      quorum_client_resp = {:ok, "1"}

      expect(QuorumClientMock, :create_verification_contract, fn _params -> quorum_client_resp end)

      contract_data = %{"email" => "alice@example.com"}
      # Start job Create verification contract
      assert :ok == Quorum.create_verification_contract(contract_data)

      # Ensure that queue contain message for create verification contract
      {payload, _queue_metadata} = pop(@queue_create_verification_contract)
      assert contract_data == Jason.decode!(payload)["payload"]

      # manually invoke message processing
      assert quorum_client_resp == CreateVerificationContract.perform(payload)
    end
  end

  @tag :pending
  describe "update user account" do
    setup do
      on_exit(fn -> purge_all(@queue_update_user_account) end)
    end

    test "success" do
      quorum_client_resp = {:ok, "updated"}
      expect(QuorumClientMock, :update_user_account, fn _params -> quorum_client_resp end)

      # Start job Create user account
      user_data = %{"transaction" => "update-user"}
      assert :ok == Quorum.update_user_account(user_data)

      # Ensure that queue contain message for user creation
      {payload, _queue_metadata} = pop(@queue_update_user_account)
      assert user_data == Jason.decode!(payload)["payload"]

      # manually invoke message processing
      assert quorum_client_resp == UpdateUserAccount.perform(payload)
    end
  end

  describe "create transaction and check status" do
    setup do
      on_exit(fn ->
        purge_all(@queue_transaction_status)
        purge_all(@queue_transaction_create)
      end)
    end

    test "success" do
      expect(QuorumClientMock, :eth_send_transaction, fn _params, _opts ->
        {:ok, "0x9b4f4029f7e13575d5f4eab2c65ccc43b21aa67f4cf0746c4500b6c80a23fc23"}
      end)

      transaction_status = %{
        "blockHash" => "0x0c8fcd90f0ba49e7d5232ce978379e27cb371a1da5a3b11ccccb36847e628d47",
        "blockNumber" => "0x3",
        "contractAddress" => "0xb9074c3296ef49f2dd7cd1afe10798ea46887434",
        "cumulativeGasUsed" => "0x5208",
        "from" => "0xaf438474fda68a51c5f3b04eb08d6b27a879ba14",
        "gasUsed" => "0x5208",
        "logs" => [],
        "logsBloom" => "0x0",
        "status" => "0x1",
        "to" => nil,
        "transactionHash" => "0x9b4f4029f7e13575d5f4eab2c65ccc43b21aa67f4cf0746c4500b6c80a23fc23",
        "transactionIndex" => "0x0"
      }

      expect(QuorumClientMock, :eth_get_transaction_receipt, fn _params, _opts -> {:ok, true} end)

      expect(QuorumClientMock, :eth_get_transaction_receipt, fn _params, _opts -> {:ok, transaction_status} end)

      expect(QuorumClientMock, :eth_get_logs, fn status, params ->
        assert transaction_status == status
        assert "test params" == params
      end)

      transaction_data = %{from: "0xaf438474fda68a51c5f3b04eb08d6b27a879ba14"}
      callback = {QuorumClientMock, :eth_get_logs, ["test params"]}

      # Start Create transaction job
      assert :ok = Quorum.create_transaction(transaction_data, callback)

      # Ensure that queue contain message for create transaction job
      assert {transaction_payload, _queue_metadata} = pop(@queue_transaction_create)

      # manually invoke create transaction job
      assert :ok == transaction_payload |> fetch_payload_from_queue() |> TransactionCreate.perform()

      # ensure that message succesfully created in transaction_status queue
      assert {status_payload, _queue_metadata} = pop(@queue_transaction_status)

      # manually invoke transaction status job
      # transaction not ready yet, task_bunny move failed job to retry queue
      assert :retry == status_payload |> fetch_payload_from_queue() |> TransactionStatus.perform()

      # on second attempt transaction status job succesfully completed
      assert :ok == status_payload |> fetch_payload_from_queue() |> TransactionStatus.perform()
    end
  end
end
