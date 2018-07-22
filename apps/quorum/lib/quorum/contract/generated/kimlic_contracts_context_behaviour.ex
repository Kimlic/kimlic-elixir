defmodule Quorum.Contracts.Generated.KimlicContractsContextBehaviour do
  @moduledoc false

  @callback renounce_ownership(keyword) :: :ok

  @callback owner(keyword) :: {:ok, binary}

  @callback transfer_ownership(term, keyword) :: :ok

  @callback get_account_storage_adapter(keyword) :: {:ok, binary}

  @callback get_kimlic_token(keyword) :: {:ok, binary}

  @callback get_verification_contract_factory(keyword) :: {:ok, binary}

  @callback get_provisioning_price_list(keyword) :: {:ok, binary}

  @callback get_verification_price_list(keyword) :: {:ok, binary}

  @callback get_provisioning_contract_factory(keyword) :: {:ok, binary}

  @callback get_community_token_wallet_address(keyword) :: {:ok, binary}

  @callback get_rewarding_contract(keyword) :: {:ok, binary}

  @callback get_account_storage(keyword) :: {:ok, binary}

  @callback get_relying_party_storage_adapter(keyword) :: {:ok, binary}

  @callback get_relying_party_storage(keyword) :: {:ok, binary}

  @callback get_attestation_party_storage_adapter(keyword) :: {:ok, binary}

  @callback get_attestation_party_storage(keyword) :: {:ok, binary}

  @callback set_account_storage_adapter(term, keyword) :: :ok

  @callback set_kimlic_token(term, keyword) :: :ok

  @callback set_verification_contract_factory(term, keyword) :: :ok

  @callback set_provisioning_price_list(term, keyword) :: :ok

  @callback set_verification_price_list(term, keyword) :: :ok

  @callback set_provisioning_contract_factory(term, keyword) :: :ok

  @callback set_community_token_wallet_address(term, keyword) :: :ok

  @callback set_rewarding_contract(term, keyword) :: :ok

  @callback set_account_storage(term, keyword) :: :ok

  @callback set_relying_party_storage_adapter(term, keyword) :: :ok

  @callback set_relying_party_storage(term, keyword) :: :ok

  @callback set_attestation_party_storage_adapter(term, keyword) :: :ok

  @callback set_attestation_party_storage(term, keyword) :: :ok
end
