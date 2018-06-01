defmodule Quorum.Contract do
  @abi_dir "lib/quorum/contract/abi"
  @contract_account_storage :account_storage
  @contract_verification_factory :verification_factory

  def contract(:account_storage), do: @contract_account_storage
  def contract(:verification_factory), do: @contract_verification_factory

  @spec hash_data(atom, binary, list) :: binary
  def hash_data(contract, function, params) do
    contract
    |> load_abi()
    |> ABI.parse_specification()
    |> Enum.find(&(&1.function == function))
    |> ABI.encode(params)
    |> Base.encode16(case: :lower)
    |> add_prefix("0x")
  end

  defp load_abi(contract) do
    # ToDo: store data in ets
    contract
    |> contract_path()
    |> File.read!()
    |> Jason.decode!()
  end

  defp contract_path(@contract_account_storage), do: @abi_dir <> "/account_storage.json"
  defp contract_path(@contract_verification_factory), do: @abi_dir <> "/verification_contract_factory.json"

  defp add_prefix(string, prefix), do: prefix <> string
end
