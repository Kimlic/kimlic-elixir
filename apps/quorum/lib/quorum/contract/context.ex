defmodule Quorum.Contract.Context do
  @moduledoc """
  Module that fetch contract adresses from KimlicContractContext contract
  """

  @kimlic_contracts_context Application.get_env(:quorum, :contracts)[:kimlic_contracts_context]
  @kimlic_context_storage Application.get_env(:quorum, :contracts)[:kimlic_context_storage]

  @spec get_kimlic_attestation_party_address :: binary
  def get_kimlic_attestation_party_address, do: Confex.fetch_env!(:quorum, :kimlic_ap_address)

  @spec address64_to_40(binary) :: binary
  def address64_to_40(address), do: String.replace(address, String.duplicate("0", 24), "")

  # ToDo: cache functions below

  @spec get_context_address :: binary
  def get_context_address,
    do:
      do_get_address(&@kimlic_context_storage.get_context/1, fn ->
        Confex.fetch_env!(:quorum, :context_storage_address)
      end)

  @spec get_verification_contract_factory_address :: binary
  def get_verification_contract_factory_address,
    do: do_get_address(&@kimlic_contracts_context.get_verification_contract_factory/1)

  @spec get_account_storage_adapter_address :: binary
  def get_account_storage_adapter_address, do: do_get_address(&@kimlic_contracts_context.get_account_storage_adapter/1)

  @spec do_get_address((binary -> {:ok, binary} | term), (() -> binary)) :: binary | {:error, tuple}
  defp do_get_address(address_resolver_func, to \\ &get_context_address/0) do
    with {:ok, address} <- address_resolver_func.(to: to.()) do
      address64_to_40(address)
    else
      err ->
        Log.error("[#{__MODULE__}] Fail to get contract address with error: #{inspect(err)}")
        {:error, {:internal_error, "Fail to get contract address "}}
    end
  end
end
