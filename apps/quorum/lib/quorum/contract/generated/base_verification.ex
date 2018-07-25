defmodule Quorum.Contracts.Generated.BaseVerification do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.BaseVerificationBehaviour

  def tokens_unlock_at(options) do
    data = Contract.hash_data(:base_verification, "tokensUnlockAt", [{}])
    quorum_client_request(data, options)
  end

  def _status(options) do
    data = Contract.hash_data(:base_verification, "_status", [{}])
    quorum_client_request(data, options)
  end

  def account_address(options) do
    data = Contract.hash_data(:base_verification, "accountAddress", [{}])
    quorum_client_request(data, options)
  end

  def renounce_ownership(options) do
    data = Contract.hash_data(:base_verification, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:base_verification, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
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
    transaction_via_queue(data, options)
  end

  def transfer_ownership_raw(newOwner, options) do
    data = Contract.hash_data(:base_verification, "transferOwnership", [{newOwner}])
    quorum_send_transaction(data, options)
  end

  def data_index(options) do
    data = Contract.hash_data(:base_verification, "dataIndex", [{}])
    quorum_client_request(data, options)
  end

  def reward_amount(options) do
    data = Contract.hash_data(:base_verification, "rewardAmount", [{}])
    quorum_client_request(data, options)
  end

  def finalize_verification(verificationResult, options) do
    data = Contract.hash_data(:base_verification, "finalizeVerification", [{verificationResult}])
    transaction_via_queue(data, options)
  end

  def finalize_verification_raw(verificationResult, options) do
    data = Contract.hash_data(:base_verification, "finalizeVerification", [{verificationResult}])
    quorum_send_transaction(data, options)
  end

  def get_data(options) do
    data = Contract.hash_data(:base_verification, "getData", [{}])
    quorum_client_request(data, options)
  end

  def withdraw(options) do
    data = Contract.hash_data(:base_verification, "withdraw", [{}])
    transaction_via_queue(data, options)
  end

  def withdraw_raw(options) do
    data = Contract.hash_data(:base_verification, "withdraw", [{}])
    quorum_send_transaction(data, options)
  end

  def get_status(options) do
    data = Contract.hash_data(:base_verification, "getStatus", [{}])
    quorum_client_request(data, options)
  end

  def get_status_name(options) do
    data = Contract.hash_data(:base_verification, "getStatusName", [{}])
    quorum_client_request(data, options)
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
