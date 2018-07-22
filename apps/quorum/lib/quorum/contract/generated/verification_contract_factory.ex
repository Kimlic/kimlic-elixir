defmodule Quorum.Contracts.Generated.VerificationContractFactory do
  @moduledoc false

  alias Quorum.Contract

  @behaviour Quorum.Contracts.Generated.VerificationContractFactoryBehaviour

  @quorum_client Application.get_env(:quorum, :client)

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

    create_transaction(data, options)
  end

  def create_phone_verification(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createPhoneVerification", [
        {account, attestationPartyAddress, key}
      ])

    create_transaction(data, options)
  end

  def create_document_verification(account, attestationPartyAddress, key, options) do
    data =
      Contract.hash_data(:verification_contract_factory, "createDocumentVerification", [
        {account, attestationPartyAddress, key}
      ])

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
