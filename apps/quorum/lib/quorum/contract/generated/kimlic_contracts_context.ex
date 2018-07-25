defmodule Quorum.Contracts.Generated.KimlicContractsContext do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.KimlicContractsContextBehaviour

  def renounce_ownership(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
  end

  def owner(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "owner", [{}])
    quorum_client_request(data, options)
  end

  def transfer_ownership(newOwner, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "transferOwnership", [{newOwner}])
    transaction_via_queue(data, options)
  end

  def transfer_ownership_raw(newOwner, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "transferOwnership", [{newOwner}])
    quorum_send_transaction(data, options)
  end

  def get_account_storage_adapter(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAccountStorageAdapter", [{}])
    quorum_client_request(data, options)
  end

  def get_kimlic_token(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getKimlicToken", [{}])
    quorum_client_request(data, options)
  end

  def get_verification_contract_factory(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getVerificationContractFactory", [{}])
    quorum_client_request(data, options)
  end

  def get_provisioning_price_list(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getProvisioningPriceList", [{}])
    quorum_client_request(data, options)
  end

  def get_verification_price_list(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getVerificationPriceList", [{}])
    quorum_client_request(data, options)
  end

  def get_provisioning_contract_factory(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getProvisioningContractFactory", [{}])
    quorum_client_request(data, options)
  end

  def get_community_token_wallet_address(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getCommunityTokenWalletAddress", [{}])
    quorum_client_request(data, options)
  end

  def get_rewarding_contract(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getRewardingContract", [{}])
    quorum_client_request(data, options)
  end

  def get_account_storage(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAccountStorage", [{}])
    quorum_client_request(data, options)
  end

  def get_relying_party_storage_adapter(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getRelyingPartyStorageAdapter", [{}])
    quorum_client_request(data, options)
  end

  def get_relying_party_storage(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getRelyingPartyStorage", [{}])
    quorum_client_request(data, options)
  end

  def get_attestation_party_storage_adapter(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAttestationPartyStorageAdapter", [{}])
    quorum_client_request(data, options)
  end

  def get_attestation_party_storage(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAttestationPartyStorage", [{}])
    quorum_client_request(data, options)
  end

  def set_account_storage_adapter(accountStorageAdapterAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorageAdapter", [{accountStorageAdapterAddress}])
    transaction_via_queue(data, options)
  end

  def set_account_storage_adapter_raw(accountStorageAdapterAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorageAdapter", [{accountStorageAdapterAddress}])
    quorum_send_transaction(data, options)
  end

  def set_kimlic_token(kimlicTokenAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setKimlicToken", [{kimlicTokenAddress}])
    transaction_via_queue(data, options)
  end

  def set_kimlic_token_raw(kimlicTokenAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setKimlicToken", [{kimlicTokenAddress}])
    quorum_send_transaction(data, options)
  end

  def set_verification_contract_factory(verificationContractFactoryAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationContractFactory", [
        {verificationContractFactoryAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_verification_contract_factory_raw(verificationContractFactoryAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationContractFactory", [
        {verificationContractFactoryAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def set_provisioning_price_list(provisioningPriceListAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setProvisioningPriceList", [{provisioningPriceListAddress}])
    transaction_via_queue(data, options)
  end

  def set_provisioning_price_list_raw(provisioningPriceListAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setProvisioningPriceList", [{provisioningPriceListAddress}])
    quorum_send_transaction(data, options)
  end

  def set_verification_price_list(verificationPriceListAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setVerificationPriceList", [{verificationPriceListAddress}])
    transaction_via_queue(data, options)
  end

  def set_verification_price_list_raw(verificationPriceListAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setVerificationPriceList", [{verificationPriceListAddress}])
    quorum_send_transaction(data, options)
  end

  def set_provisioning_contract_factory(provisioningContractFactoryAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningContractFactory", [
        {provisioningContractFactoryAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_provisioning_contract_factory_raw(provisioningContractFactoryAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningContractFactory", [
        {provisioningContractFactoryAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def set_community_token_wallet_address(communityTokenWalletAddressAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setCommunityTokenWalletAddress", [
        {communityTokenWalletAddressAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_community_token_wallet_address_raw(communityTokenWalletAddressAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setCommunityTokenWalletAddress", [
        {communityTokenWalletAddressAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def set_rewarding_contract(rewardingContractAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRewardingContract", [{rewardingContractAddress}])
    transaction_via_queue(data, options)
  end

  def set_rewarding_contract_raw(rewardingContractAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRewardingContract", [{rewardingContractAddress}])
    quorum_send_transaction(data, options)
  end

  def set_account_storage(accountStorageAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorage", [{accountStorageAddress}])
    transaction_via_queue(data, options)
  end

  def set_account_storage_raw(accountStorageAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorage", [{accountStorageAddress}])
    quorum_send_transaction(data, options)
  end

  def set_relying_party_storage_adapter(relyingPartyStorageAdapterAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorageAdapter", [
        {relyingPartyStorageAdapterAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_relying_party_storage_adapter_raw(relyingPartyStorageAdapterAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorageAdapter", [
        {relyingPartyStorageAdapterAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def set_relying_party_storage(relyingPartyStorageAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorage", [{relyingPartyStorageAddress}])
    transaction_via_queue(data, options)
  end

  def set_relying_party_storage_raw(relyingPartyStorageAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorage", [{relyingPartyStorageAddress}])
    quorum_send_transaction(data, options)
  end

  def set_attestation_party_storage_adapter(attestationPartyStorageAdapterAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorageAdapter", [
        {attestationPartyStorageAdapterAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_attestation_party_storage_adapter_raw(attestationPartyStorageAdapterAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorageAdapter", [
        {attestationPartyStorageAdapterAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def set_attestation_party_storage(attestationPartyStorageAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorage", [{attestationPartyStorageAddress}])

    transaction_via_queue(data, options)
  end

  def set_attestation_party_storage_raw(attestationPartyStorageAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorage", [{attestationPartyStorageAddress}])

    quorum_send_transaction(data, options)
  end

  @spec quorum_client_request(map, keyword) :: {:ok, binary}
  defp quorum_client_request(data, options) do
    data
    |> prepare_params(options)
    |> QuorumClient.eth_call("latest", [])
  end

  @spec quorum_send_transaction(map, keyword) :: {:ok, binary}
  defp quorum_send_transaction(data, options) do
    data
    |> prepare_params(options)
    |> Map.merge(%{gasPrice: "0x0", gas: "0x500000"})
    |> QuorumClient.eth_send_transaction([])
  end

  @spec transaction_via_queue(map, map) :: :ok
  defp transaction_via_queue(data, options) do
    data
    |> prepare_params(options)
    |> Quorum.create_transaction(Keyword.get(options, :meta, %{}))
  end

  @spec prepare_params(map, keyword) :: map
  defp prepare_params(data, options) do
    options
    |> Enum.into(%{})
    |> Map.take([:from, :to])
    |> Map.merge(%{data: data})
  end
end
