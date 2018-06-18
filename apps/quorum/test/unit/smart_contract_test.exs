defmodule Quorum.Unit.SmartContractTest do
  use ExUnit.Case

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  @tag :pending
  test "create Email verification contract" do
    # assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])

    account_address = "0x63b1b67b599ba2de0d04287102c8b2ae85e209b3"
    kimlic_ap_address = "0x63b1b67b599ba2de0d04287102c8b2ae85e209b3"
    verification_contract_factory_address = "0x8e21e0f68fa040601dab389add2a98331d2ad674"

    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    index = 1
    return_key = UUID.uuid4()

    data =
      Contract.hash_data(:verification_factory, "createEmailVerification", [
        account_address,
        kimlic_ap_address,
        index,
        account_address,
        return_key
      ])

    assert {:ok, transaction_hash} =
             QuorumHttpClient.eth_send_transaction(%{
               from: account_address,
               data: data,
               to: verification_contract_factory_address,
               gasPrice: "0x0",
               gas: "0x500000"
             })

    :timer.sleep(50)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"
    assert "0x1" == map["status"], "Invalid transaction status. Expected \"0x1\", get: #{inspect(map["status"])}}"

    data = Contract.hash_data(:verification_factory, "getVerificationContract", [{return_key}])

    :timer.sleep(50)

    assert {:ok, address} = QuorumHttpClient.eth_call(%{data: data, to: verification_contract_factory_address})
    assert is_binary(address), "Expected address from Quorum.getVerificationContract, get: #{inspect(address)}"
    IO.inspect(address)
  end
end
