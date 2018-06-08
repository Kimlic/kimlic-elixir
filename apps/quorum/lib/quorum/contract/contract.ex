defmodule Quorum.Contract do
  @moduledoc false

  alias Quorum.ABI

  @abi_dir __DIR__ <> "/abi"
  @contract_account_storage :account_storage
  @contract_base_verification :base_verification
  @contract_verification_factory :verification_factory

  @spec contract(atom) :: atom
  def contract(:account_storage), do: @contract_account_storage
  def contract(:verification_factory), do: @contract_verification_factory
  def contract(:base_verification), do: @contract_base_verification

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

  @spec load_abi(atom) :: [map]
  defp load_abi(contract) do
    # ToDo: store data in ets
    contract
    |> contract_path()
    |> File.read!()
    |> Jason.decode!()
  end

  @spec contract_path(atom) :: binary
  defp contract_path(@contract_account_storage), do: @abi_dir <> "/account_storage.json"
  defp contract_path(@contract_verification_factory), do: @abi_dir <> "/verification_contract_factory.json"
  defp contract_path(@contract_base_verification), do: @abi_dir <> "/base_verification.json"

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
