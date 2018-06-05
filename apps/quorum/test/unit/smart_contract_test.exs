defmodule Quorum.Unit.SmartContractTest do
  use ExUnit.Case

  alias Quorum.ABI
  alias Ethereumex.HttpClient, as: QuorumHttpClient

  @tag :pending
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
      assert is_map(map)

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
      assert is_map(map)
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
