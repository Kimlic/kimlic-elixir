defmodule Quorum.Unit.QuorumTest do
  use ExUnit.Case

  import Quorum.QueueTestHelper
  import Mox

  alias Core.Jobs.{CreateUserAccount, CreateVerificationContract}
  alias Quorum.Jobs.{UpdateUserAccount}

  doctest Quorum

  setup :verify_on_exit!
  setup :set_mox_global

  @queue_create_user_account "kimlic-core-test.create-user-account"
  @queue_create_verification_contract "kimlic-core-test.create-verification-contract"
  @queue_update_user_account "kimlic-core-test.update-user-account"

  describe "create user account" do
    setup do
      on_exit(fn ->
        purge(@queue_create_user_account)
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

  describe "create verification contract" do
    setup do
      on_exit(fn ->
        purge(@queue_create_verification_contract)
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

  describe "update user account" do
    setup do
      on_exit(fn -> purge(@queue_update_user_account) end)
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
end
