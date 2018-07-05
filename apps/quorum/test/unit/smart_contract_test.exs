defmodule Quorum.Unit.SmartContractTest do
  use ExUnit.Case

  alias Quorum.Contract
  alias Quorum.Contract.Context
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  @tag :pending
  test "create Email verification contract" do
    account_address = init_quorum_user()
    kimlic_ap_address = Context.get_kimlic_attestation_party_address()
    verification_contract_factory_address = Contract.Context.get_verification_contract_factory_address()

    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [kimlic_ap_address, "Kimlicp@ssw0rd"], [])

    return_key = UUID.uuid4()

    data =
      Contract.hash_data(:verification_factory, "createEmailVerification", [
        {account_address, kimlic_ap_address, return_key}
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

  defp init_quorum_user do
    assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    transaction_data = %{
      from: account_address,
      to: Context.get_account_storage_adapter_address(),
      data:
        Contract.hash_data(:account_storage_adapter, "setAccountFieldMainData", [
          {"#{:rand.uniform()}", "email"}
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
