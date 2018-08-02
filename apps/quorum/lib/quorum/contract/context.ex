defmodule Quorum.Contract.Context do
  @moduledoc """
  Module that fetch contract adresses from KimlicContractContext contract
  """

  alias Quorum.Contract
  alias Quorum.Contract.Generated.KimlicContextStorage
  alias Quorum.Contract.Generated.KimlicContractsContext

  @quorum_client Application.get_env(:quorum, :client)

  @spec get_kimlic_attestation_party_address :: binary
  def get_kimlic_attestation_party_address do
    Confex.fetch_env!(:quorum, :kimlic_ap_address)
  end

  # ToDo: add cache

  @spec get_context_address :: binary
  def get_context_address do
    context_storage_address = Confex.fetch_env!(:quorum, :context_storage_address)
    {:ok, address} = @quorum_client.eth_call(%{to: context_storage_address, data: "0x127f0f07"}, "latest", [])
    #    {:ok, address} = KimlicContextStorage.get_context(%{to: Confex.fetch_env!(:quorum, :context_storage_address)})
    address64_to_40(address)
  end

  @spec get_account_storage_adapter_address :: binary
  def get_account_storage_adapter_address do
    data = Contract.hash_data(:kimlic_contracts_context, "getAccountStorageAdapter", [{}])
    {:ok, address} = @quorum_client.eth_call(%{to: get_context_address(), data: data}, "latest", [])

    #    {:ok, address} = KimlicContractsContext.get_account_storage_adapter(%{to: get_context_address()})
    address64_to_40(address)
  end

  @spec get_verification_contract_factory_address :: binary
  def get_verification_contract_factory_address do
    {:ok, address} = @quorum_client.eth_call(%{to: get_context_address(), data: "0x22d2dd34"}, "latest", [])
    #    {:ok, address} = KimlicContractsContext.get_verification_contract_factory(%{to: get_context_address()})
    address64_to_40(address)
  end

  @spec address64_to_40(binary) :: binary
  def address64_to_40(address), do: String.replace(address, String.duplicate("0", 24), "")
end
