defmodule Quorum.Contracts.Generated.BaseVerification do
  @moduledoc false

  alias Quorum.Contract

  @behaviour Quorum.Contracts.Generated.BaseVerificationBehaviour

  @quorum_client Application.get_env(:quorum, :client)

  def tokens_unlock_at(options) do
    data = Contract.hash_data(:base_verification, "tokensUnlockAt", [{}])

    quorum_client_request(data, options)
  end

  def attestation_party(options) do
    data = Contract.hash_data(:base_verification, "attestationParty", [{}])

    quorum_client_request(data, options)
  end

  def account_address(options) do
    data = Contract.hash_data(:base_verification, "accountAddress", [{}])

    quorum_client_request(data, options)
  end

  def status(options) do
    data = Contract.hash_data(:base_verification, "status", [{}])

    quorum_client_request(data, options)
  end

  def renounce_ownership(options) do
    data = Contract.hash_data(:base_verification, "renounceOwnership", [{}])

    create_transaction(data, options)
  end

  def verified_at(options) do
    data = Contract.hash_data(:base_verification, "verifiedAt", [{}])

    quorum_client_request(data, options)
  end

  def owner(options) do
    data = Contract.hash_data(:base_verification, "owner", [{}])

    quorum_client_request(data, options)
  end

  def account_field_name(options) do
    data = Contract.hash_data(:base_verification, "accountFieldName", [{}])

    quorum_client_request(data, options)
  end

  def co_owner(options) do
    data = Contract.hash_data(:base_verification, "coOwner", [{}])

    quorum_client_request(data, options)
  end

  def transfer_ownership(newOwner, options) do
    data = Contract.hash_data(:base_verification, "transferOwnership", [{newOwner}])

    create_transaction(data, options)
  end

  def data_index(options) do
    data = Contract.hash_data(:base_verification, "dataIndex", [{}])

    quorum_client_request(data, options)
  end

  def set_verification_result(verificationResult, options) do
    data = Contract.hash_data(:base_verification, "setVerificationResult", [{verificationResult}])

    create_transaction(data, options)
  end

  def get_data(options) do
    data = Contract.hash_data(:base_verification, "getData", [{}])

    quorum_client_request(data, options)
  end

  def withdraw(options) do
    data = Contract.hash_data(:base_verification, "withdraw", [{}])

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
