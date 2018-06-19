defmodule Quorum.Unit.SmartContractTest do
  use ExUnit.Case

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  @tag :pending
  test "create Email verification contract" do
    # assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])

    account_address = "0x63b1b67b599ba2de0d04287102c8b2ae85e209b3"
    kimlic_ap_address = "0x6ad58c4fd879b94400eef71e40747ac743b6031f"
    verification_contract_factory_address = "0x2d819f3832ec0fecc8eec4efe4e1a596878b2079"

    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [kimlic_ap_address, "Kimlicp@ssw0rd"], [])

    index = 1
    return_key = UUID.uuid4()

    data =
      Contract.hash_data(:verification_factory, "createEmailVerification", [
        {account_address, kimlic_ap_address, index, kimlic_ap_address, return_key}
      ])

    tx_data = %{
      from: kimlic_ap_address,
      data: data,
      to: verification_contract_factory_address,
      gasPrice: "0x0",
      gas: "0x500000"
    }

    assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(tx_data)

    :timer.sleep(70)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    msg = "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"
    assert "0x1" == map["status"], msg

    data = Contract.hash_data(:verification_factory, "getVerificationContract", [{return_key}])

    :timer.sleep(50)

    assert {:ok, contract_address} = QuorumHttpClient.eth_call(%{data: data, to: verification_contract_factory_address})
    msg = "Expected address from Quorum.getVerificationContract, get: #{inspect(contract_address)}"
    assert is_binary(contract_address), msg
    refute "0x0000000000000000000000000000000000000000000000000000000000000000" == contract_address

    contract_address = String.replace(contract_address, "000000000000000000000000", "")

    data = Contract.hash_data(:base_verification, "setVerificationResult", [{true}])

    tx_data = %{
      from: kimlic_ap_address,
      data: data,
      to: contract_address,
      gasPrice: "0x0",
      gas: "0x500000"
    }

    assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(tx_data)

    :timer.sleep(70)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    msg = "Invalid transaction status. Expected \"0x1\", get: #{map["status"]}"
    assert "0x1" == map["status"], msg
  end
end
