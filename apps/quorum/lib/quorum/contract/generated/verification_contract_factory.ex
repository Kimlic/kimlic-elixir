defmodule Quorum.Contracts.Generated.VerificationContractFactory do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.VerificationContractFactoryBehaviour

  @spec created_contracts(term, keyword) :: {:ok, binary}
  def created_contracts(param1, options) do
    data = Contract.hash_data(:verification_contract_factory, "createdContracts", [{param1}])
    quorum_client_request(data, options)
  end

  @spec get_verification_contract(term, keyword) :: {:ok, binary}
  def get_verification_contract(key, options) do
    data = Contract.hash_data(:verification_contract_factory, "getVerificationContract", [{key}])
    quorum_client_request(data, options)
  end

  @spec create_email_verification(term, term, term, keyword) :: :ok
  def create_email_verification(account, attestation_party_address, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createEmailVerification", [
        {account, attestation_party_address, key}
      ])

    transaction_via_queue(data, options)
  end

  @spec create_email_verification_raw(term, term, term, keyword) :: :ok
  def create_email_verification_raw(account, attestation_party_address, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createEmailVerification", [
        {account, attestation_party_address, key}
      ])

    quorum_send_transaction(data, options)
  end

  @spec create_phone_verification(term, term, term, keyword) :: :ok
  def create_phone_verification(account, attestation_party_address, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createPhoneVerification", [
        {account, attestation_party_address, key}
      ])

    transaction_via_queue(data, options)
  end

  @spec create_phone_verification_raw(term, term, term, keyword) :: :ok
  def create_phone_verification_raw(account, attestation_party_address, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createPhoneVerification", [
        {account, attestation_party_address, key}
      ])

    quorum_send_transaction(data, options)
  end

  @spec create_document_verification(term, term, term, keyword) :: :ok
  def create_document_verification(account, attestation_party_address, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createDocumentVerification", [
        {account, attestation_party_address, key}
      ])

    transaction_via_queue(data, options)
  end

  @spec create_document_verification_raw(term, term, term, keyword) :: :ok
  def create_document_verification_raw(account, attestation_party_address, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createDocumentVerification", [
        {account, attestation_party_address, key}
      ])

    quorum_send_transaction(data, options)
  end

  @spec create_base_verification_contract(term, term, term, term, keyword) :: :ok
  def create_base_verification_contract(account, attestation_party_address, key, account_field_name, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account, attestation_party_address, key, account_field_name}
      ])

    transaction_via_queue(data, options)
  end

  @spec create_base_verification_contract_raw(term, term, term, term, keyword) :: :ok
  def create_base_verification_contract_raw(account, attestation_party_address, key, account_field_name, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account, attestation_party_address, key, account_field_name}
      ])

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
