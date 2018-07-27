defmodule Quorum.Contract.Generated.BaseVerification do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contract.Generated.BaseVerificationBehaviour

  @spec tokens_unlock_at(keyword) :: {:ok, binary}
  def tokens_unlock_at(options) do
    data = Contract.hash_data(:base_verification, "tokensUnlockAt", [{}])
    quorum_client_request(data, options)
  end

  @spec _status(keyword) :: {:ok, binary}
  def _status(options) do
    data = Contract.hash_data(:base_verification, "_status", [{}])
    quorum_client_request(data, options)
  end

  @spec account_address(keyword) :: {:ok, binary}
  def account_address(options) do
    data = Contract.hash_data(:base_verification, "accountAddress", [{}])
    quorum_client_request(data, options)
  end

  @spec renounce_ownership(keyword) :: :ok
  def renounce_ownership(options) do
    data = Contract.hash_data(:base_verification, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  @spec renounce_ownership_raw(keyword) :: :ok
  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:base_verification, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
  end

  @spec verified_at(keyword) :: {:ok, binary}
  def verified_at(options) do
    data = Contract.hash_data(:base_verification, "verifiedAt", [{}])
    quorum_client_request(data, options)
  end

  @spec owner(keyword) :: {:ok, binary}
  def owner(options) do
    data = Contract.hash_data(:base_verification, "owner", [{}])
    quorum_client_request(data, options)
  end

  @spec account_field_name(keyword) :: {:ok, binary}
  def account_field_name(options) do
    data = Contract.hash_data(:base_verification, "accountFieldName", [{}])
    quorum_client_request(data, options)
  end

  @spec co_owner(keyword) :: {:ok, binary}
  def co_owner(options) do
    data = Contract.hash_data(:base_verification, "coOwner", [{}])
    quorum_client_request(data, options)
  end

  @spec transfer_ownership(term, keyword) :: :ok
  def transfer_ownership(new_owner, options) do
    data = Contract.hash_data(:base_verification, "transferOwnership", [{new_owner}])
    transaction_via_queue(data, options)
  end

  @spec transfer_ownership_raw(term, keyword) :: :ok
  def transfer_ownership_raw(new_owner, options) do
    data = Contract.hash_data(:base_verification, "transferOwnership", [{new_owner}])
    quorum_send_transaction(data, options)
  end

  @spec data_index(keyword) :: {:ok, binary}
  def data_index(options) do
    data = Contract.hash_data(:base_verification, "dataIndex", [{}])
    quorum_client_request(data, options)
  end

  @spec reward_amount(keyword) :: {:ok, binary}
  def reward_amount(options) do
    data = Contract.hash_data(:base_verification, "rewardAmount", [{}])
    quorum_client_request(data, options)
  end

  @spec finalize_verification(term, keyword) :: :ok
  def finalize_verification(verification_result, options) do
    data = Contract.hash_data(:base_verification, "finalizeVerification", [{verification_result}])
    transaction_via_queue(data, options)
  end

  @spec finalize_verification_raw(term, keyword) :: :ok
  def finalize_verification_raw(verification_result, options) do
    data = Contract.hash_data(:base_verification, "finalizeVerification", [{verification_result}])
    quorum_send_transaction(data, options)
  end

  @spec get_data(keyword) :: {:ok, binary}
  def get_data(options) do
    data = Contract.hash_data(:base_verification, "getData", [{}])
    quorum_client_request(data, options)
  end

  @spec withdraw(keyword) :: :ok
  def withdraw(options) do
    data = Contract.hash_data(:base_verification, "withdraw", [{}])
    transaction_via_queue(data, options)
  end

  @spec withdraw_raw(keyword) :: :ok
  def withdraw_raw(options) do
    data = Contract.hash_data(:base_verification, "withdraw", [{}])
    quorum_send_transaction(data, options)
  end

  @spec get_status(keyword) :: {:ok, binary}
  def get_status(options) do
    data = Contract.hash_data(:base_verification, "getStatus", [{}])
    quorum_client_request(data, options)
  end

  @spec get_status_name(keyword) :: {:ok, binary}
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
