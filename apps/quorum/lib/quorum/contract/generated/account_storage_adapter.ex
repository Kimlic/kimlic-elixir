defmodule Quorum.Contracts.Generated.AccountStorageAdapter do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.AccountStorageAdapterBehaviour

  @spec renounce_ownership(keyword) :: :ok
  def renounce_ownership(options) do
    data = Contract.hash_data(:account_storage_adapter, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  @spec renounce_ownership_raw(keyword) :: :ok
  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:account_storage_adapter, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
  end

  @spec owner(keyword) :: {:ok, binary}
  def owner(options) do
    data = Contract.hash_data(:account_storage_adapter, "owner", [{}])
    quorum_client_request(data, options)
  end

  @spec transfer_ownership(term, keyword) :: :ok
  def transfer_ownership(new_owner, options) do
    data = Contract.hash_data(:account_storage_adapter, "transferOwnership", [{new_owner}])
    transaction_via_queue(data, options)
  end

  @spec transfer_ownership_raw(term, keyword) :: :ok
  def transfer_ownership_raw(new_owner, options) do
    data = Contract.hash_data(:account_storage_adapter, "transferOwnership", [{new_owner}])
    quorum_send_transaction(data, options)
  end

  @spec add_allowed_field_name(term, keyword) :: :ok
  def add_allowed_field_name(field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "addAllowedFieldName", [{field_name}])
    transaction_via_queue(data, options)
  end

  @spec add_allowed_field_name_raw(term, keyword) :: :ok
  def add_allowed_field_name_raw(field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "addAllowedFieldName", [{field_name}])
    quorum_send_transaction(data, options)
  end

  @spec remove_allowed_field_name(term, keyword) :: :ok
  def remove_allowed_field_name(field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "removeAllowedFieldName", [{field_name}])
    transaction_via_queue(data, options)
  end

  @spec remove_allowed_field_name_raw(term, keyword) :: :ok
  def remove_allowed_field_name_raw(field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "removeAllowedFieldName", [{field_name}])
    quorum_send_transaction(data, options)
  end

  @spec is_allowed_field_name(term, keyword) :: {:ok, binary}
  def is_allowed_field_name(field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "isAllowedFieldName", [{field_name}])
    quorum_client_request(data, options)
  end

  @spec set_field_main_data(term, term, keyword) :: :ok
  def set_field_main_data(data, account_field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "setFieldMainData", [{data, account_field_name}])
    transaction_via_queue(data, options)
  end

  @spec set_field_main_data_raw(term, term, keyword) :: :ok
  def set_field_main_data_raw(data, account_field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "setFieldMainData", [{data, account_field_name}])
    quorum_send_transaction(data, options)
  end

  @spec get_field_details(term, term, keyword) :: {:ok, binary}
  def get_field_details(account_address, account_field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldDetails", [{account_address, account_field_name}])
    quorum_client_request(data, options)
  end

  @spec get_last_field_verification_contract_address(term, term, keyword) :: {:ok, binary}
  def get_last_field_verification_contract_address(account_address, account_field_name, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getLastFieldVerificationContractAddress", [
        {account_address, account_field_name}
      ])

    quorum_client_request(data, options)
  end

  @spec get_field_verification_contract_address(term, term, term, keyword) :: {:ok, binary}
  def get_field_verification_contract_address(account_address, account_field_name, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldVerificationContractAddress", [
        {account_address, account_field_name, index}
      ])

    quorum_client_request(data, options)
  end

  @spec get_field_last_main_data(term, term, keyword) :: {:ok, binary}
  def get_field_last_main_data(account_address, account_field_name, options) do
    data = Contract.hash_data(:account_storage_adapter, "getFieldLastMainData", [{account_address, account_field_name}])
    quorum_client_request(data, options)
  end

  @spec get_field_main_data(term, term, term, keyword) :: {:ok, binary}
  def get_field_main_data(account_address, account_field_name, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldMainData", [{account_address, account_field_name, index}])

    quorum_client_request(data, options)
  end

  @spec get_field_last_verification_data(term, term, keyword) :: {:ok, binary}
  def get_field_last_verification_data(account_address, account_field_name, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldLastVerificationData", [
        {account_address, account_field_name}
      ])

    quorum_client_request(data, options)
  end

  @spec get_field_verification_data(term, term, term, keyword) :: {:ok, binary}
  def get_field_verification_data(account_address, account_field_name, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldVerificationData", [
        {account_address, account_field_name, index}
      ])

    quorum_client_request(data, options)
  end

  @spec get_is_field_verification_contract_exist(term, term, term, keyword) :: {:ok, binary}
  def get_is_field_verification_contract_exist(account_address, account_field_name, index, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getIsFieldVerificationContractExist", [
        {account_address, account_field_name, index}
      ])

    quorum_client_request(data, options)
  end

  @spec set_field_last_verification_contract_address(term, term, term, keyword) :: :ok
  def set_field_last_verification_contract_address(
        account_address,
        account_field_name,
        verification_contract_address,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldLastVerificationContractAddress", [
        {account_address, account_field_name, verification_contract_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_field_last_verification_contract_address_raw(term, term, term, keyword) :: :ok
  def set_field_last_verification_contract_address_raw(
        account_address,
        account_field_name,
        verification_contract_address,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldLastVerificationContractAddress", [
        {account_address, account_field_name, verification_contract_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec set_field_verification_contract_address(term, term, term, term, keyword) :: :ok
  def set_field_verification_contract_address(
        account_address,
        account_field_name,
        index,
        verification_contract_address,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldVerificationContractAddress", [
        {account_address, account_field_name, index, verification_contract_address}
      ])

    transaction_via_queue(data, options)
  end

  @spec set_field_verification_contract_address_raw(term, term, term, term, keyword) :: :ok
  def set_field_verification_contract_address_raw(
        account_address,
        account_field_name,
        index,
        verification_contract_address,
        options
      ) do
    data =
      Contract.hash_data(:account_storage_adapter, "setFieldVerificationContractAddress", [
        {account_address, account_field_name, index, verification_contract_address}
      ])

    quorum_send_transaction(data, options)
  end

  @spec get_field_history_length(term, term, keyword) :: {:ok, binary}
  def get_field_history_length(account_address, account_field_name, options) do
    data =
      Contract.hash_data(:account_storage_adapter, "getFieldHistoryLength", [{account_address, account_field_name}])

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
