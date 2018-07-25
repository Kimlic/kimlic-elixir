defmodule Quorum.Contracts.Generated.AccountStorageAdapter do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.AccountStorageAdapterBehaviour

  def renounce_ownership(options) do
    data = Contract.hash_data(:account_storage_adapter, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:account_storage_adapter, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
  end

  def owner(options) do
    data = Contract.hash_data(:account_storage_adapter, "owner", [{}])
    quorum_client_request(data, options)
  end

  def transfer_ownership(newOwner, options) do
    data = Contract.hash_data(:account_storage_adapter, "transferOwnership", [{newOwner}])
    transaction_via_queue(data, options)
  end

  def transfer_ownership_raw(newOwner, options) do
    data = Contract.hash_data(:account_storage_adapter, "transferOwnership", [{newOwner}])
    quorum_send_transaction(data, options)
  end

  def add_allowed_field_name(fieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "addAllowedFieldName", [{fieldName}])
    transaction_via_queue(data, options)
  end

  def add_allowed_field_name_raw(fieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "addAllowedFieldName", [{fieldName}])
    quorum_send_transaction(data, options)
  end

  def remove_allowed_field_name(fieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "removeAllowedFieldName", [{fieldName}])
    transaction_via_queue(data, options)
  end

  def remove_allowed_field_name_raw(fieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "removeAllowedFieldName", [{fieldName}])
    quorum_send_transaction(data, options)
  end

  def is_allowed_field_name(fieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "isAllowedFieldName", [{fieldName}])
    quorum_client_request(data, options)
  end

  def set_field_main_data(data, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "setFieldMainData", [{data, accountFieldName}])
    transaction_via_queue(data, options)
  end

  def set_field_main_data_raw(data, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "setFieldMainData", [{data, accountFieldName}])
    quorum_send_transaction(data, options)
  end

  def get_field_details(accountAddress, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldDetails", [{accountAddress, accountFieldName}])
    quorum_client_request(data, options)
  end

  def get_last_field_verification_contract_address(accountAddress, accountFieldName, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getLastFieldVerificationContractAddress", [
        {accountAddress, accountFieldName}
      ])

    quorum_client_request(data, options)
  end

  def get_field_verification_contract_address(accountAddress, accountFieldName, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldVerificationContractAddress", [
        {accountAddress, accountFieldName, index}
      ])

    quorum_client_request(data, options)
  end

  def get_field_last_main_data(accountAddress, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldLastMainData", [{accountAddress, accountFieldName}])
    quorum_client_request(data, options)
  end

  def get_field_main_data(accountAddress, accountFieldName, index, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldMainData", [{accountAddress, accountFieldName, index}])
    quorum_client_request(data, options)
  end

  def get_field_last_verification_data(accountAddress, accountFieldName, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldLastVerificationData", [{accountAddress, accountFieldName}])

    quorum_client_request(data, options)
  end

  def get_field_verification_data(accountAddress, accountFieldName, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldVerificationData", [
        {accountAddress, accountFieldName, index}
      ])

    quorum_client_request(data, options)
  end

  def get_is_field_verification_contract_exist(accountAddress, accountFieldName, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getIsFieldVerificationContractExist", [
        {accountAddress, accountFieldName, index}
      ])

    quorum_client_request(data, options)
  end

  def set_field_last_verification_contract_address(
        accountAddress,
        accountFieldName,
        verificationContractAddress,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldLastVerificationContractAddress", [
        {accountAddress, accountFieldName, verificationContractAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_field_last_verification_contract_address_raw(
        accountAddress,
        accountFieldName,
        verificationContractAddress,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldLastVerificationContractAddress", [
        {accountAddress, accountFieldName, verificationContractAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def set_field_verification_contract_address(
        accountAddress,
        accountFieldName,
        index,
        verificationContractAddress,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldVerificationContractAddress", [
        {accountAddress, accountFieldName, index, verificationContractAddress}
      ])

    transaction_via_queue(data, options)
  end

  def set_field_verification_contract_address_raw(
        accountAddress,
        accountFieldName,
        index,
        verificationContractAddress,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldVerificationContractAddress", [
        {accountAddress, accountFieldName, index, verificationContractAddress}
      ])

    quorum_send_transaction(data, options)
  end

  def get_field_history_length(accountAddress, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldHistoryLength", [{accountAddress, accountFieldName}])
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
