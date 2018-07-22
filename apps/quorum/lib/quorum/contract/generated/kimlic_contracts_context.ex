defmodule Quorum.Contracts.Generated.KimlicContractsContext do
  @moduledoc false

  alias Quorum.Contract

  @behaviour Quorum.Contracts.Generated.KimlicContractsContextBehaviour

  @quorum_client Application.get_env(:quorum, :client)

  def renounce_ownership(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "renounceOwnership", [{}])

    create_transaction(data, options)
  end

  def owner(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "owner", [{}])

    quorum_client_request(data, options)
  end

  def transfer_ownership(newOwner, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "transferOwnership", [{newOwner}])

    create_transaction(data, options)
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

    create_transaction(data, options)
  end

  def set_kimlic_token(kimlicTokenAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setKimlicToken", [{kimlicTokenAddress}])

    create_transaction(data, options)
  end

  def set_verification_contract_factory(verificationContractFactoryAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationContractFactory", [
        {verificationContractFactoryAddress}
      ])

    create_transaction(data, options)
  end

  def set_provisioning_price_list(provisioningPriceListAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setProvisioningPriceList", [{provisioningPriceListAddress}])

    create_transaction(data, options)
  end

  def set_verification_price_list(verificationPriceListAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setVerificationPriceList", [{verificationPriceListAddress}])

    create_transaction(data, options)
  end

  def set_provisioning_contract_factory(provisioningContractFactoryAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningContractFactory", [
        {provisioningContractFactoryAddress}
      ])

    create_transaction(data, options)
  end

  def set_community_token_wallet_address(communityTokenWalletAddressAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setCommunityTokenWalletAddress", [
        {communityTokenWalletAddressAddress}
      ])

    create_transaction(data, options)
  end

  def set_rewarding_contract(rewardingContractAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRewardingContract", [{rewardingContractAddress}])

    create_transaction(data, options)
  end

  def set_account_storage(accountStorageAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorage", [{accountStorageAddress}])

    create_transaction(data, options)
  end

  def set_relying_party_storage_adapter(relyingPartyStorageAdapterAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorageAdapter", [
        {relyingPartyStorageAdapterAddress}
      ])

    create_transaction(data, options)
  end

  def set_relying_party_storage(relyingPartyStorageAddress, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorage", [{relyingPartyStorageAddress}])

    create_transaction(data, options)
  end

  def set_attestation_party_storage_adapter(attestationPartyStorageAdapterAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorageAdapter", [
        {attestationPartyStorageAdapterAddress}
      ])

    create_transaction(data, options)
  end

  def set_attestation_party_storage(attestationPartyStorageAddress, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorage", [{attestationPartyStorageAddress}])

    create_transaction(data, options)
  end

  @spec prepare_params(map, keyword) :: map
  defp prepare_params(data, options) do
    options
    |> Enum.into(%{})
    |> Map.take([:from, :to])
    |> Map.merge(%{data: data})
  end

  @spec quorum_client_request(map, keyword) :: {:ok, binary}
  defp quorum_client_request(data, options) do
    data
    |> prepare_params(options)
    |> @quorum_client.eth_call("latest", [])
  end

  @spec create_transaction(map, map) :: :ok
  defp create_transaction(data, options) do
    data
    |> prepare_params(options)
    |> Quorum.create_transaction(Keyword.get(options, :meta, %{}))
  end
end
