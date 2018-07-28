defmodule Quorum.Unit.SmartContractTest do
  @moduledoc false

  use ExUnit.Case
  alias Quorum.Contract.Context

  # Quorum environment enabled
  @moduletag :integration

  @quorum_client Application.get_env(:quorum, :client)
  @account_storage_adapter Application.get_env(:quorum, :contracts)[:account_storage_adapter]
  @base_verification Application.get_env(:quorum, :contracts)[:base_verification]
  @verification_contract_factory Application.get_env(:quorum, :contracts)[:verification_contract_factory]

  @hashed_true "0x0000000000000000000000000000000000000000000000000000000000000001"
  @hashed_false "0x0000000000000000000000000000000000000000000000000000000000000000"

  @tag :pending
  test "create Email verification contract" do
    account_address = init_quorum_user()
    kimlic_ap_address = Context.get_kimlic_attestation_party_address()
    kimlic_ap_password = Confex.fetch_env!(:quorum, :kimlic_ap_password)
    verification_contract_factory_address = Context.get_verification_contract_factory_address()

    assert {:ok, _} = @quorum_client.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])
    assert {:ok, _} = @quorum_client.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    return_key = UUID.uuid4()

    assert {:ok, transaction_hash} =
             @verification_contract_factory.create_base_verification_contract_raw(
               account_address,
               kimlic_ap_address,
               return_key,
               "email",
               from: kimlic_ap_address,
               to: verification_contract_factory_address
             )

    :timer.sleep(70)
    assert {:ok, map} = @quorum_client.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    assert "0x1" == map["status"], "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"

    :timer.sleep(50)

    assert {:ok, contract_address} =
             @verification_contract_factory.get_verification_contract(
               return_key,
               to: verification_contract_factory_address
             )

    msg = "Expected address from Quorum.getVerificationContract, get: #{inspect(contract_address)}"
    assert is_binary(contract_address), msg
    refute @hashed_false == contract_address

    contract_address = Context.address64_to_40(contract_address)

    assert {:ok, transaction_hash} =
             @base_verification.finalize_verification_raw(true, from: kimlic_ap_address, to: contract_address)

    :timer.sleep(70)
    assert {:ok, map} = @quorum_client.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    msg = "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"
    assert "0x1" == map["status"], msg
  end

  @tag :pending
  test "check that account field email not set" do
    assert {:ok, account_address} = @quorum_client.request("personal_newAccount", ["p@ssW0rd"], [])

    assert {:ok, @hashed_false} =
             @account_storage_adapter.get_field_history_length(
               account_address,
               "email",
               to: Context.get_account_storage_adapter_address()
             )
  end

  @tag :pending
  test "check that account field email set" do
    account_address = init_quorum_user()

    assert {:ok, @hashed_true} =
             @account_storage_adapter.get_field_history_length(
               account_address,
               "email",
               to: Context.get_account_storage_adapter_address()
             )
  end

  @spec init_quorum_user :: binary
  defp init_quorum_user do
    assert {:ok, account_address} = @quorum_client.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = @quorum_client.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    {:ok, transaction_hash} =
      @account_storage_adapter.set_field_main_data_raw(
        to_string(:rand.uniform()),
        "email",
        from: account_address,
        to: Context.get_account_storage_adapter_address()
      )

    :timer.sleep(75)

    {:ok, %{"status" => "0x1"}} = @quorum_client.eth_get_transaction_receipt(transaction_hash, [])
    :timer.sleep(75)

    account_address
  end
end
