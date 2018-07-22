defmodule Quorum.Contracts.Generated.AccountStorageAdapter do
  @moduledoc false

  alias Quorum.Contract

  @behaviour Quorum.Contracts.Generated.AccountStorageAdapterBehaviour

  @quorum_client Application.get_env(:quorum, :client)

  def renounce_ownership(options) do
    data = Contract.hash_data(:account_storage_adapter, "renounceOwnership", [{}])

    create_transaction(data, options)
  end

  def owner(options) do
    data = Contract.hash_data(:account_storage_adapter, "owner", [{}])

    quorum_client_request(data, options)
  end

  def transfer_ownership(newOwner, options) do
    data = Contract.hash_data(:account_storage_adapter, "transferOwnership", [{newOwner}])

    create_transaction(data, options)
  end

  def add_allowed_column_name(columnName, options) do
    data = Contract.hash_data(:account_storage_adapter, "addAllowedColumnName", [{columnName}])

    create_transaction(data, options)
  end

  def remove_allowed_column_name(columnName, options) do
    data = Contract.hash_data(:account_storage_adapter, "removeAllowedColumnName", [{columnName}])

    create_transaction(data, options)
  end

  def is_allowed_column_name(columnName, options) do
    data = Contract.hash_data(:account_storage_adapter, "isAllowedColumnName", [{columnName}])

    quorum_client_request(data, options)
  end

  def set_account_field_main_data(data, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "setAccountFieldMainData", [{data, accountFieldName}])

    create_transaction(data, options)
  end

  def get_last_account_data_verification_contract_address(accountAddress, accountFieldName, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getLastAccountDataVerificationContractAddress", [
        {accountAddress, accountFieldName}
      ])

    quorum_client_request(data, options)
  end

  def get_account_data_verification_contract_address(accountAddress, accountFieldName, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getAccountDataVerificationContractAddress", [
        {accountAddress, accountFieldName, index}
      ])

    quorum_client_request(data, options)
  end

  def get_account_field_last_main_data(accountAddress, accountFieldName, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getAccountFieldLastMainData", [{accountAddress, accountFieldName}])

    quorum_client_request(data, options)
  end

  def get_account_field_main_data(accountAddress, accountFieldName, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getAccountFieldMainData", [
        {accountAddress, accountFieldName, index}
      ])

    quorum_client_request(data, options)
  end

  def get_account_field_last_verification_data(accountAddress, accountFieldName, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getAccountFieldLastVerificationData", [
        {accountAddress, accountFieldName}
      ])

    quorum_client_request(data, options)
  end

  def get_account_field_verification_data(accountAddress, accountFieldName, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getAccountFieldVerificationData", [
        {accountAddress, accountFieldName, index}
      ])

    quorum_client_request(data, options)
  end

  def set_account_field_verification_contract_address(
        accountAddress,
        accountFieldName,
        verificationContractAddress,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setAccountFieldVerificationContractAddress", [
        {accountAddress, accountFieldName, verificationContractAddress}
      ])

    create_transaction(data, options)
  end

  def set_account_field_verification_contract_address(
        accountAddress,
        accountFieldName,
        index,
        verificationContractAddress,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setAccountFieldVerificationContractAddress", [
        {accountAddress, accountFieldName, index, verificationContractAddress}
      ])

    create_transaction(data, options)
  end

  def get_field_history_length(accountAddress, accountFieldName, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldHistoryLength", [{accountAddress, accountFieldName}])

    quorum_client_request(data, options)
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
