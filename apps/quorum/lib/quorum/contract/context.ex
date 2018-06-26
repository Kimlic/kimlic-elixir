defmodule Quorum.Contract.Context do
  @moduledoc """
  Module that fetch contract adresses from KimlicContractContext contract
  """

  @quorum_client Application.get_env(:quorum, :client)

  def get_verification_contract_factory_address do
    # ToDo: add cache
    {:ok, address} = @quorum_client.eth_call(%{to: get_context_address(), data: "0x22d2dd34"}, "latest", [])
    address64_to_40(address)
  end

  def get_kimlic_attestation_party_address do
    Confex.fetch_env!(:quorum, :kimlil_ap_address)
  end

  defp get_context_address do
    # ToDo: add cache
    context_storage_address = Confex.fetch_env!(:quorum, :context_storage_address)
    {:ok, address} = @quorum_client.eth_call(%{to: context_storage_address, data: "0x127f0f07"}, "latest", [])
    address64_to_40(address)
  end

  defp address64_to_40(address), do: String.replace(address, String.duplicate("0", 24), "")
end
