defmodule Quorum.Contract do
  @moduledoc false

  alias Quorum.ABI
  alias Quorum.ABI.TypeEncoder

  @abi_dir "priv/abi"

  @contract_account_storage :account_storage
  @contract_base_verification :base_verification
  @contract_verification_factory :verification_factory

  @spec contract(atom) :: atom
  def contract(:account_storage), do: @contract_account_storage
  def contract(:verification_factory), do: @contract_verification_factory
  def contract(:base_verification), do: @contract_base_verification

  @doc """
  Special case for getVerificationContract because of {:tuple, [:string]} ABI description
  For String type required head with 32 bytes, ABI library will generate it only for tuple type
  """
  @spec hash_data(atom, binary, list) :: binary
  def hash_data(:verification_factory, "getVerificationContract", params) do
    params
    |> Enum.map(&string_to_tuple/1)
    |> TypeEncoder.encode_raw([{:tuple, [:string]}])
    |> Base.encode16(case: :lower)
    |> add_prefix("0x8575e5a5")
  end

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

  @spec string_to_tuple(binary) :: tuple
  defp string_to_tuple(string) when is_binary(string), do: {string}
  @spec string_to_tuple(term) :: term
  defp string_to_tuple(value), do: value

  @spec load_abi(atom) :: [map]
  defp load_abi(contract) do
    # ToDo: store data in ets
    contract
    |> contract_path()
    |> File.read!()
    |> Jason.decode!()
  end

  @spec contract_path(atom) :: binary
  defp contract_path(@contract_account_storage), do: Application.app_dir(:quorum, @abi_dir <> "/account_storage.json")

  defp contract_path(@contract_verification_factory),
    do: Application.app_dir(:quorum, @abi_dir <> "/verification_contract_factory.json")

  defp contract_path(@contract_base_verification),
    do: Application.app_dir(:quorum, @abi_dir <> "/base_verification.json")

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
