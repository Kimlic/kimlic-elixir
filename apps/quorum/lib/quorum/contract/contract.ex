defmodule Quorum.Contract do
  @moduledoc false

  alias Quorum.ABI

  @abi_dir "priv/abi"

  @contract_account_storage :account_storage
  @contract_base_verification :base_verification
  @contract_verification_factory :verification_factory

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
  defp contract_path(@contract_account_storage), do: Application.app_dir(:quorum, @abi_dir <> "/AccountStorage.json")

  defp contract_path(@contract_verification_factory),
    do: Application.app_dir(:quorum, @abi_dir <> "/VerificationContractFactory.json")

  defp contract_path(@contract_base_verification),
    do: Application.app_dir(:quorum, @abi_dir <> "/BaseVerification.json")

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
