defmodule Quorum.Contract.Context do
  @moduledoc """
  Module that fetch contract adresses from KimlicContractContext contract
  """

  alias Quorum.Contract

  @quorum_client Application.get_env(:quorum, :client)

  @spec get_verification_contract_factory_address :: binary
  def get_verification_contract_factory_address do
    # ToDo: add cache
    {:ok, address} = @quorum_client.eth_call(%{to: get_context_address(), data: "0x22d2dd34"}, "latest", [])
    address64_to_40(address)
  end

  @spec get_kimlic_attestation_party_address :: binary
  def get_kimlic_attestation_party_address do
    Confex.fetch_env!(:quorum, :kimlic_ap_address)
  end

  @spec get_context_address :: binary
  def get_context_address do
    # ToDo: add cache
    context_storage_address = Confex.fetch_env!(:quorum, :context_storage_address)
    {:ok, address} = @quorum_client.eth_call(%{to: context_storage_address, data: "0x127f0f07"}, "latest", [])
    address64_to_40(address)
  end

  @spec get_account_storage_adapter_address :: binary
  def get_account_storage_adapter_address do
    data = Contract.hash_data(:kimlic_contracts_context, "getAccountStorageAdapter", [{}])
    {:ok, address} = @quorum_client.eth_call(%{to: get_context_address(), data: data}, "latest", [])
    address64_to_40(address)
  end

  @spec address64_to_40(binary) :: binary
  def address64_to_40(address), do: String.replace(address, String.duplicate("0", 24), "")
end
