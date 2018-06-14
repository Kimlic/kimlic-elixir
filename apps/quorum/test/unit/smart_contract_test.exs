defmodule Quorum.Unit.SmartContractTest do
  use ExUnit.Case

  alias Quorum.{ABI, Contract}
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  @tag :pending
  test "create Email verification contract" do
#    assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])

    verif_contract_address = "0x8e21e0f68fa040601dab389add2a98331d2ad674"

    account_address = "0x63b1b67b599ba2de0d04287102c8b2ae85e209b3"
    assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    return_key = "test"

    data = Contract.hash_data(:verification_factory, "createEmailVerification", [account_address, account_address, return_key])

#    data = "0xb1b5dcf5000000000000000000000000ca35b7d915458ef540ade6068dfe2f44e8fa733c000000000000000000000000ca35b7d915458ef540ade6068dfe2f44e8fa733c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000047465737400000000000000000000000000000000000000000000000000000000"
    assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(%{from: account_address, data: data, to: verif_contract_address, gasPrice: "0x0", gas: "0x500000"})

    :timer.sleep(50)
    assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
    IO.inspect(map, label: "\nResponse: createEmailVerification")
    assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"

    data = Contract.hash_data(:verification_factory, "getVerificationContract", [return_key])


    IO.inspect(data)
    System.halt()

    :timer.sleep(50)
#    dats = "0x8575e5a5000000000000000000000000000000000000000000000000000000000000002431303032383262322d366538632d346663302d623633652d31623963383266643662613300000000000000000000000000000000000000000000000000000000
#    dat1 = "0x8575e5a500000000000000000000000000000000000000000000000000000000000000047465737400000000000000000000000000000000000000000000000000000000"
#    data = "0x8575e5a50000000000000000000#00000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000047465737400000000000000000000000000000000000000000000000000000000"

    assert {:ok, map} = QuorumHttpClient.eth_call(%{data: data, to: verif_contract_address})
    IO.inspect(map, label: "\nResponse: getVerificationContract")
    System.halt()
    assert is_map(map), "Expected map from Quorum.debug_traceTransaction, get: #{inspect(map)}"
  end

  describe "deploy contract and fetch method" do
    test "happy path" do
      assert {:ok, account_address} = QuorumHttpClient.request("personal_newAccount", ["p@ssW0rd"], [])
      assert {:ok, _} = QuorumHttpClient.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

      contract_transaction = %{
        from: account_address,
        data:
          "0x608060405234801561001057600080fd5b5060dc8061001f6000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806309ce9ccb14604e578063987dc56b146076575b600080fd5b348015605957600080fd5b50606060a0565b6040518082815260200191505060405180910390f35b348015608157600080fd5b50609e6004803603810190808035906020019092919050505060a6565b005b60005481565b80600081905550505600a165627a7a72305820de321601a738155356acb02b4168a9e2446c9d3c417a98c806b1a8751a6767290029"
      }

      assert {:ok, transaction_hash} = QuorumHttpClient.eth_send_transaction(contract_transaction)

      :timer.sleep(50)
      assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
      assert is_map(map), "Expected map from Quorum, get: #{inspect(map)}"

      contract_func =
        abi()
        |> ABI.parse_specification()
        |> Enum.find(&(&1.function == "addTwoNumbers"))
        |> ABI.encode([1])
        |> Base.encode16(case: :lower)

      assert {:ok, transaction_hash} =
               QuorumHttpClient.eth_send_transaction(%{from: account_address, data: "0x" <> contract_func})

      :timer.sleep(50)
      assert {:ok, map} = QuorumHttpClient.eth_get_transaction_receipt(transaction_hash, [])
      assert is_map(map), "Expected map from Quorum.eth_get_transaction_receipt, get: #{inspect(map)}"

      assert {:ok, map} = QuorumHttpClient.request("debug_traceTransaction", [transaction_hash], [])
      assert is_map(map), "Expected map from Quorum.debug_traceTransaction, get: #{inspect(map)}"
    end
  end

  defp abi do
    [
      %{
        "constant" => true,
        "inputs" => [],
        "name" => "storedNumber",
        "outputs" => [
          %{
            "name" => "",
            "type" => "uint256"
          }
        ],
        "payable" => false,
        "stateMutability" => "view",
        "type" => "function"
      },
      %{
        "constant" => false,
        "inputs" => [
          %{
            "name" => "number",
            "type" => "uint256"
          }
        ],
        "name" => "addTwoNumbers",
        "outputs" => [],
        "payable" => false,
        "stateMutability" => "nonpayable",
        "type" => "function"
      }
    ]
  end
end
