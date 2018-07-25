defmodule Quorum.Contracts.Generated.VerificationContractFactory do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.VerificationContractFactoryBehaviour

  def created_contracts(param1, options) do
    data = Contract.hash_data(:verification_contract_factory, "createdContracts", [{param1}])
    quorum_client_request(data, options)
  end

  def get_verification_contract(key, options) do
    data = Contract.hash_data(:verification_contract_factory, "getVerificationContract", [{key}])
    quorum_client_request(data, options)
  end

  def create_email_verification(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createEmailVerification", [
        {account, attestationPartyAddress, key}
      ])

    transaction_via_queue(data, options)
  end

  def create_email_verification_raw(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createEmailVerification", [
        {account, attestationPartyAddress, key}
      ])

    quorum_send_transaction(data, options)
  end

  def create_phone_verification(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createPhoneVerification", [
        {account, attestationPartyAddress, key}
      ])

    transaction_via_queue(data, options)
  end

  def create_phone_verification_raw(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createPhoneVerification", [
        {account, attestationPartyAddress, key}
      ])

    quorum_send_transaction(data, options)
  end

  def create_document_verification(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createDocumentVerification", [
        {account, attestationPartyAddress, key}
      ])

    transaction_via_queue(data, options)
  end

  def create_document_verification_raw(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createDocumentVerification", [
        {account, attestationPartyAddress, key}
      ])

    quorum_send_transaction(data, options)
  end

  def create_base_verification_contract(account, attestationPartyAddress, key, accountFieldName, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account, attestationPartyAddress, key, accountFieldName}
      ])

    transaction_via_queue(data, options)
  end

  def create_base_verification_contract_raw(account, attestationPartyAddress, key, accountFieldName, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account, attestationPartyAddress, key, accountFieldName}
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
