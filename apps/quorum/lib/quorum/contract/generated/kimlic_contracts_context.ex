defmodule Quorum.Contracts.Generated.KimlicContractsContext do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.KimlicContractsContextBehaviour

  @spec renounce_ownership(keyword) :: :ok
  def renounce_ownership(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  @spec renounce_ownership_raw(keyword) :: :ok
  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
  end

  @spec owner(keyword) :: {:ok, binary}
  def owner(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "owner", [{}])
    quorum_client_request(data, options)
  end

  @spec transfer_ownership(term, keyword) :: :ok
  def transfer_ownership(new_owner, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "transferOwnership", [{new_owner}])
    transaction_via_queue(data, options)
  end

  @spec transfer_ownership_raw(term, keyword) :: :ok
  def transfer_ownership_raw(new_owner, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "transferOwnership", [{new_owner}])
    quorum_send_transaction(data, options)
  end

  @spec get_account_storage_adapter(keyword) :: {:ok, binary}
  def get_account_storage_adapter(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAccountStorageAdapter", [{}])
    quorum_client_request(data, options)
  end

  @spec get_kimlic_token(keyword) :: {:ok, binary}
  def get_kimlic_token(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getKimlicToken", [{}])
    quorum_client_request(data, options)
  end

  @spec get_verification_contract_factory(keyword) :: {:ok, binary}
  def get_verification_contract_factory(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getVerificationContractFactory", [{}])
    quorum_client_request(data, options)
  end

  @spec get_provisioning_price_list(keyword) :: {:ok, binary}
  def get_provisioning_price_list(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getProvisioningPriceList", [{}])
    quorum_client_request(data, options)
  end

  @spec get_verification_price_list(keyword) :: {:ok, binary}
  def get_verification_price_list(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getVerificationPriceList", [{}])
    quorum_client_request(data, options)
  end

  @spec get_provisioning_contract_factory(keyword) :: {:ok, binary}
  def get_provisioning_contract_factory(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getProvisioningContractFactory", [{}])
    quorum_client_request(data, options)
  end

  @spec get_community_token_wallet_address(keyword) :: {:ok, binary}
  def get_community_token_wallet_address(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getCommunityTokenWalletAddress", [{}])
    quorum_client_request(data, options)
  end

  @spec get_rewarding_contract(keyword) :: {:ok, binary}
  def get_rewarding_contract(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getRewardingContract", [{}])
    quorum_client_request(data, options)
  end

  @spec get_account_storage(keyword) :: {:ok, binary}
  def get_account_storage(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAccountStorage", [{}])
    quorum_client_request(data, options)
  end

  @spec get_relying_party_storage_adapter(keyword) :: {:ok, binary}
  def get_relying_party_storage_adapter(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getRelyingPartyStorageAdapter", [{}])
    quorum_client_request(data, options)
  end

  @spec get_relying_party_storage(keyword) :: {:ok, binary}
  def get_relying_party_storage(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getRelyingPartyStorage", [{}])
    quorum_client_request(data, options)
  end

  @spec get_attestation_party_storage_adapter(keyword) :: {:ok, binary}
  def get_attestation_party_storage_adapter(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAttestationPartyStorageAdapter", [{}])
    quorum_client_request(data, options)
  end

  @spec get_attestation_party_storage(keyword) :: {:ok, binary}
  def get_attestation_party_storage(options) do
    data = Contract.hash_data(:kimlic_contracts_context, "getAttestationPartyStorage", [{}])
    quorum_client_request(data, options)
  end

  @spec set_account_storage_adapter(term, keyword) :: :ok
  def set_account_storage_adapter(account_storage_adapter_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAccountStorageAdapter", [{account_storage_adapter_address}])

    transaction_via_queue(data, options)
  end

  @spec set_account_storage_adapter_raw(term, keyword) :: :ok
  def set_account_storage_adapter_raw(account_storage_adapter_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAccountStorageAdapter", [{account_storage_adapter_address}])

    quorum_send_transaction(data, options)
  end

  @spec set_kimlic_token(term, keyword) :: :ok
  def set_kimlic_token(kimlic_token_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setKimlicToken", [{kimlic_token_address}])
    transaction_via_queue(data, options)
  end

  @spec set_kimlic_token_raw(term, keyword) :: :ok
  def set_kimlic_token_raw(kimlic_token_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setKimlicToken", [{kimlic_token_address}])
    quorum_send_transaction(data, options)
  end

  @spec set_verification_contract_factory(term, keyword) :: :ok
  def set_verification_contract_factory(verification_contract_factory_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationContractFactory", [
        {verification_contract_factory_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_verification_contract_factory_raw(term, keyword) :: :ok
  def set_verification_contract_factory_raw(verification_contract_factory_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationContractFactory", [
        {verification_contract_factory_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec set_provisioning_price_list(term, keyword) :: :ok
  def set_provisioning_price_list(provisioning_price_list_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningPriceList", [{provisioning_price_list_address}])

    transaction_via_queue(data, options)
  end

  @spec set_provisioning_price_list_raw(term, keyword) :: :ok
  def set_provisioning_price_list_raw(provisioning_price_list_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningPriceList", [{provisioning_price_list_address}])

    quorum_send_transaction(data, options)
  end

  @spec set_verification_price_list(term, keyword) :: :ok
  def set_verification_price_list(verification_price_list_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationPriceList", [{verification_price_list_address}])

    transaction_via_queue(data, options)
  end

  @spec set_verification_price_list_raw(term, keyword) :: :ok
  def set_verification_price_list_raw(verification_price_list_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setVerificationPriceList", [{verification_price_list_address}])

    quorum_send_transaction(data, options)
  end

  @spec set_provisioning_contract_factory(term, keyword) :: :ok
  def set_provisioning_contract_factory(provisioning_contract_factory_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningContractFactory", [
        {provisioning_contract_factory_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_provisioning_contract_factory_raw(term, keyword) :: :ok
  def set_provisioning_contract_factory_raw(provisioning_contract_factory_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setProvisioningContractFactory", [
        {provisioning_contract_factory_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec set_community_token_wallet_address(term, keyword) :: :ok
  def set_community_token_wallet_address(community_token_wallet_address_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setCommunityTokenWalletAddress", [
        {community_token_wallet_address_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_community_token_wallet_address_raw(term, keyword) :: :ok
  def set_community_token_wallet_address_raw(community_token_wallet_address_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setCommunityTokenWalletAddress", [
        {community_token_wallet_address_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec set_rewarding_contract(term, keyword) :: :ok
  def set_rewarding_contract(rewarding_contract_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRewardingContract", [{rewarding_contract_address}])
    transaction_via_queue(data, options)
  end

  @spec set_rewarding_contract_raw(term, keyword) :: :ok
  def set_rewarding_contract_raw(rewarding_contract_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRewardingContract", [{rewarding_contract_address}])
    quorum_send_transaction(data, options)
  end

  @spec set_account_storage(term, keyword) :: :ok
  def set_account_storage(account_storage_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorage", [{account_storage_address}])
    transaction_via_queue(data, options)
  end

  @spec set_account_storage_raw(term, keyword) :: :ok
  def set_account_storage_raw(account_storage_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setAccountStorage", [{account_storage_address}])
    quorum_send_transaction(data, options)
  end

  @spec set_relying_party_storage_adapter(term, keyword) :: :ok
  def set_relying_party_storage_adapter(relying_party_storage_adapter_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorageAdapter", [
        {relying_party_storage_adapter_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_relying_party_storage_adapter_raw(term, keyword) :: :ok
  def set_relying_party_storage_adapter_raw(relying_party_storage_adapter_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorageAdapter", [
        {relying_party_storage_adapter_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec set_relying_party_storage(term, keyword) :: :ok
  def set_relying_party_storage(relying_party_storage_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorage", [{relying_party_storage_address}])
    transaction_via_queue(data, options)
  end

  @spec set_relying_party_storage_raw(term, keyword) :: :ok
  def set_relying_party_storage_raw(relying_party_storage_address, options) do
    data = Contract.hash_data(:kimlic_contracts_context, "setRelyingPartyStorage", [{relying_party_storage_address}])
    quorum_send_transaction(data, options)
  end

  @spec set_attestation_party_storage_adapter(term, keyword) :: :ok
  def set_attestation_party_storage_adapter(attestation_party_storage_adapter_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorageAdapter", [
        {attestation_party_storage_adapter_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_attestation_party_storage_adapter_raw(term, keyword) :: :ok
  def set_attestation_party_storage_adapter_raw(attestation_party_storage_adapter_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorageAdapter", [
        {attestation_party_storage_adapter_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec set_attestation_party_storage(term, keyword) :: :ok
  def set_attestation_party_storage(attestation_party_storage_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorage", [{attestation_party_storage_address}])

    transaction_via_queue(data, options)
  end

  @spec set_attestation_party_storage_raw(term, keyword) :: :ok
  def set_attestation_party_storage_raw(attestation_party_storage_address, options) do
    data =
      Contract.hash_data(:kimlic_contracts_context, "setAttestationPartyStorage", [{attestation_party_storage_address}])

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
