defmodule Quorum.Contract do
  @moduledoc false

  alias Quorum.ABI
  alias Quorum.Contract.Store, as: ContractStore
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contract.Behaviour

  @spec call_function(atom, binary, list, map) :: {:ok, binary}
  def call_function(contract, function, args, options \\ %{}) do
    options
    |> Map.put(:data, hash_data(contract, function, args))
    |> Quorum.create_transaction()
  end

  @spec eth_call(atom, binary, list, map) :: {:ok, binary}
  def eth_call(contract, function, args, options \\ %{}) do
    options
    |> Map.put(:data, hash_data(contract, function, args))
    |> QuorumClient.eth_call("latest", [])
  end

  @spec hash_data(atom, binary, list) :: binary
  def hash_data(contract, function, params) when is_atom(contract) do
    contract
    |> ContractStore.get()
    |> ABI.parse_specification()
    |> Enum.find(&(&1.function == function))
    |> ABI.encode(params)
    |> Base.encode16(case: :lower)
    |> add_prefix("0x")
  end

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
