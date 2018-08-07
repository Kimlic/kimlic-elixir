defmodule Quorum.Unit.SmartContractTest do
  use ExUnit.Case

  alias Quorum.Contract
  alias Quorum.Contract.Context
  alias Quorum.Contract.Generated.AccountStorageAdapter
  alias Quorum.Contract.Generated.BaseVerification
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  @hashed_true "0x0000000000000000000000000000000000000000000000000000000000000001"
  @hashed_false "0x0000000000000000000000000000000000000000000000000000000000000000"

  @tag :pending
  test "create Email verification contract" do
    account_address = init_quorum_user()
    kimlic_ap_address = Context.get_kimlic_attestation_party_address()
    kimlic_ap_password = Confex.fetch_env!(:quorum, :kimlic_ap_password)
    verification_contract_factory_address = Context.get_verification_contract_factory_address()

    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    # create Base verification contract form email
    #
    return_key = UUID.uuid4()

    data =
      Contract.hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account_address, kimlic_ap_address, return_key, "email"}
      ])

    tx_data = %{
      from: kimlic_ap_address,
      data: data,
      to: verification_contract_factory_address,
      gasPrice: "0x0",
      gas: Quorum.gas()
    }

    assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(tx_data)

    :timer.sleep(70)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    msg = "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"
    assert "0x1" == map["status"], msg

    # get created verification contract address
    #
    data = Contract.hash_data(:verification_contract_factory, "getVerificationContract", [{return_key}])

    :timer.sleep(50)

    assert {:ok, contract_address} = QuorumHttpClient.eth_call(%{data: data, to: verification_contract_factory_address})
    msg = "Expected address from Quorum.getVerificationContract, get: #{inspect(contract_address)}"
    assert is_binary(contract_address), msg
    refute @hashed_false == contract_address

    contract_address = String.replace(contract_address, String.duplicate("0", 24), "")

    # finalize verification
    #
    data = Contract.hash_data(:base_verification, "finalizeVerification", [{true}])

    tx_data = %{
      from: kimlic_ap_address,
      data: data,
      to: contract_address,
      gasPrice: "0x0",
      gas: Quorum.gas()
    }

    assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(tx_data)

    :timer.sleep(70)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    msg = "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"
    assert "0x1" == map["status"], msg
  end

  @tag :pending
  test "withdraw tokens" do
    account_address = init_quorum_user()
    kimlic_ap_address = Context.get_kimlic_attestation_party_address()
    kimlic_ap_password = Confex.fetch_env!(:quorum, :kimlic_ap_password)
    verification_contract_factory_address = Context.get_verification_contract_factory_address()

    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    # create Base verification contract form email
    #
    return_key = UUID.uuid4()

    data =
      Contract.hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account_address, kimlic_ap_address, return_key, "email"}
      ])

    tx_data = %{
      from: kimlic_ap_address,
      data: data,
      to: verification_contract_factory_address,
      gasPrice: "0x0",
      gas: Quorum.gas()
    }

    assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(tx_data)

    :timer.sleep(70)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}}"
    msg = "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"
    assert "0x1" == map["status"], msg

    # get created verification contract address
    #
    data = Contract.hash_data(:verification_contract_factory, "getVerificationContract", [{return_key}])

    :timer.sleep(50)

    assert {:ok, contract_address} = QuorumHttpClient.eth_call(%{data: data, to: verification_contract_factory_address})
    msg = "Expected address from Quorum.getVerificationContract, get: #{inspect(contract_address)}"
    assert is_binary(contract_address), msg
    refute @hashed_false == contract_address

    contract_address = String.replace(contract_address, String.duplicate("0", 24), "")

    # check contract expiration time
    #
    user_address = Confex.fetch_env!(:quorum, :profile_sync_user_address)
    password = Confex.fetch_env!(:quorum, :profile_sync_user_password)
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [user_address, password], [])

    #    data = Contract.hash_data(:verification_contract_factory, "tokensUnlockAt", [])
    #    |> IO.inspect()

    hash_tokens_unlock_at = "0x009aa2aa"
    params = %{data: hash_tokens_unlock_at, from: user_address, to: contract_address}

    assert {:ok, hashed_time} = QuorumHttpClient.eth_call(params)

    assert {:ok, time} = BaseVerification.tokens_unlock_at(%{from: user_address, to: contract_address})
    assert is_integer(time)

    assert :ok = BaseVerification.withdraw(%{from: user_address, to: contract_address})
  end

  @tag :pending
  test "check that account field email not set" do
    assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])

    params = %{
      to: Context.get_account_storage_adapter_address(),
      data: Contract.hash_data(:account_storage_adapter, "getFieldHistoryLength", [{account_address, "email"}])
    }

    assert {:ok, @hashed_false} = QuorumHttpClient.eth_call(params)
  end

  @tag :pending
  test "check that account field email set" do
    account_address = init_quorum_user()
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    assert {:ok, @hashed_true} =
             AccountStorageAdapter.get_field_history_length(
               account_address,
               "email",
               %{to: Context.get_account_storage_adapter_address()}
             )
  end

  defp init_quorum_user do
    assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    transaction_data = %{
      from: account_address,
      to: Context.get_account_storage_adapter_address(),
      data:
        Contract.hash_data(:account_storage_adapter, "setFieldMainData", [
          {"#{:rand.uniform()}", "email"}
        ]),
      gasPrice: "0x0",
      gas: Quorum.gas()
    }

    {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(transaction_data, [])
    :timer.sleep(75)

    {:ok, %{"status" => "0x1"}} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    :timer.sleep(75)

    account_address
  end
end
