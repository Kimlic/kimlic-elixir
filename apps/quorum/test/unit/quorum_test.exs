defmodule Quorum.Unit.QuorumTest do
  use ExUnit.Case

  import Mox
  import Quorum.QueueTestHelper

  alias TaskBunny.Queue
  alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

  doctest Quorum

  setup :verify_on_exit!
  setup :set_mox_global

  @queue_transaction_create "kimlic-core-test.transaction"
  @queue_transaction_status "kimlic-core-test.transaction-status"

  setup do
    clean(Queue.queue_with_subqueues(@queue_transaction_create))
    clean(Queue.queue_with_subqueues(@queue_transaction_status))
    Queue.declare_with_subqueues(:default, @queue_transaction_create)
    Queue.declare_with_subqueues(:default, @queue_transaction_status)
    :ok
  end

  describe "create verification_contract" do
    test "success" do
      expect(QuorumClientMock, :eth_send_transaction, fn _params, _opts ->
        {:ok, "0x9b4f4029f7e13575d5f4eab2c65ccc43b21aa67f4cf0746c4500b6c80a23fc23"}
      end)

      expect(QuorumClientMock, :eth_get_transaction_receipt, fn _params, _opts ->
        {:ok, %{"transactionHash" => "0x9b4f4029f7e13575d5f4eab2c65ccc43b21aa67f4cf0746"}}
      end)

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "debug_traceTransaction" == method
        {:ok, %{"returnValue" => "0x9b4f4029f7e13575d5f4eab2c65ccc43b21aa67f4cf0555"}}
      end)

      expect(QuorumClientMock, :eth_get_logs, fn status, return_value ->
        assert %{"transactionHash" => _} = status
        assert {:ok, "0x9b4f4029f7e13575d5f4eab2c65ccc43b21aa67f4cf0555"} = return_value
      end)

      # ToDo: too short address, ABI compile raise error: Data overflow encoding uint, data cannot fit in 160 bits
      account_address = "0x6cc3a44428c1722ee2fd2eb6d72387f4bc62449c"

      callback = {QuorumClientMock, :eth_get_logs, []}
      assert :ok = Quorum.create_verification_contract(account_address, :email, callback)

      # Ensure that queue contain message for create transaction job
      assert {transaction_payload, _queue_metadata} = pop(@queue_transaction_create)

      # manually invoke create transaction job
      assert :ok == transaction_payload |> fetch_payload_from_queue() |> TransactionCreate.perform()

      # ensure that message succesfully created in transaction_status queue
      assert {status_payload, _queue_metadata} = pop(@queue_transaction_status)

      # manually invoke transaction status job
      assert :ok == status_payload |> fetch_payload_from_queue() |> TransactionStatus.perform()
    end
  end

  describe "create transaction and check status" do
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

      expect(QuorumClientMock, :eth_get_logs, fn requested_arg, status ->
        assert transaction_status == status
        assert "callback" == requested_arg
      end)

      transaction_data = %{from: "0xaf438474fda68a51c5f3b04eb08d6b27a879ba14"}
      callback = {QuorumClientMock, :eth_get_logs, ["callback"]}

      # Start Create transaction job
      assert :ok = Quorum.create_transaction(transaction_data, callback, false)

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
