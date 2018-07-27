defmodule Quorum.Contract.Generated.KimlicContextStorage do
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contract.Generated.KimlicContextStorageBehaviour

  @spec delete_bytes32(term, keyword) :: :ok
  def delete_bytes32(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteBytes32", [{key}])
    transaction_via_queue(data, options)
  end

  @spec delete_bytes32_raw(term, keyword) :: :ok
  def delete_bytes32_raw(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteBytes32", [{key}])
    quorum_send_transaction(data, options)
  end

  @spec delete_address(term, keyword) :: :ok
  def delete_address(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteAddress", [{key}])
    transaction_via_queue(data, options)
  end

  @spec delete_address_raw(term, keyword) :: :ok
  def delete_address_raw(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteAddress", [{key}])
    quorum_send_transaction(data, options)
  end

  @spec get_address(term, keyword) :: {:ok, binary}
  def get_address(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getAddress", [{key}])
    quorum_client_request(data, options)
  end

  @spec delete_bool(term, keyword) :: :ok
  def delete_bool(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteBool", [{key}])
    transaction_via_queue(data, options)
  end

  @spec delete_bool_raw(term, keyword) :: :ok
  def delete_bool_raw(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteBool", [{key}])
    quorum_send_transaction(data, options)
  end

  @spec set_int(term, term, keyword) :: :ok
  def set_int(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setInt", [{key, value}])
    transaction_via_queue(data, options)
  end

  @spec set_int_raw(term, term, keyword) :: :ok
  def set_int_raw(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setInt", [{key, value}])
    quorum_send_transaction(data, options)
  end

  @spec set_bytes32(term, term, keyword) :: :ok
  def set_bytes32(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setBytes32", [{key, value}])
    transaction_via_queue(data, options)
  end

  @spec set_bytes32_raw(term, term, keyword) :: :ok
  def set_bytes32_raw(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setBytes32", [{key, value}])
    quorum_send_transaction(data, options)
  end

  @spec set_string(term, term, keyword) :: :ok
  def set_string(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setString", [{key, value}])
    transaction_via_queue(data, options)
  end

  @spec set_string_raw(term, term, keyword) :: :ok
  def set_string_raw(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setString", [{key, value}])
    quorum_send_transaction(data, options)
  end

  @spec renounce_ownership(keyword) :: :ok
  def renounce_ownership(options) do
    data = Contract.hash_data(:kimlic_context_storage, "renounceOwnership", [{}])
    transaction_via_queue(data, options)
  end

  @spec renounce_ownership_raw(keyword) :: :ok
  def renounce_ownership_raw(options) do
    data = Contract.hash_data(:kimlic_context_storage, "renounceOwnership", [{}])
    quorum_send_transaction(data, options)
  end

  @spec get_bool(term, keyword) :: {:ok, binary}
  def get_bool(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getBool", [{key}])
    quorum_client_request(data, options)
  end

  @spec delete_int(term, keyword) :: :ok
  def delete_int(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteInt", [{key}])
    transaction_via_queue(data, options)
  end

  @spec delete_int_raw(term, keyword) :: :ok
  def delete_int_raw(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteInt", [{key}])
    quorum_send_transaction(data, options)
  end

  @spec owner(keyword) :: {:ok, binary}
  def owner(options) do
    data = Contract.hash_data(:kimlic_context_storage, "owner", [{}])
    quorum_client_request(data, options)
  end

  @spec get_string(term, keyword) :: {:ok, binary}
  def get_string(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getString", [{key}])
    quorum_client_request(data, options)
  end

  @spec get_bytes32(term, keyword) :: {:ok, binary}
  def get_bytes32(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getBytes32", [{key}])
    quorum_client_request(data, options)
  end

  @spec set_bool(term, term, keyword) :: :ok
  def set_bool(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setBool", [{key, value}])
    transaction_via_queue(data, options)
  end

  @spec set_bool_raw(term, term, keyword) :: :ok
  def set_bool_raw(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setBool", [{key, value}])
    quorum_send_transaction(data, options)
  end

  @spec get_uint(term, keyword) :: {:ok, binary}
  def get_uint(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getUint", [{key}])
    quorum_client_request(data, options)
  end

  @spec set_address(term, term, keyword) :: :ok
  def set_address(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setAddress", [{key, value}])
    transaction_via_queue(data, options)
  end

  @spec set_address_raw(term, term, keyword) :: :ok
  def set_address_raw(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setAddress", [{key, value}])
    quorum_send_transaction(data, options)
  end

  @spec get_int(term, keyword) :: {:ok, binary}
  def get_int(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getInt", [{key}])
    quorum_client_request(data, options)
  end

  @spec set_uint(term, term, keyword) :: :ok
  def set_uint(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setUint", [{key, value}])
    transaction_via_queue(data, options)
  end

  @spec set_uint_raw(term, term, keyword) :: :ok
  def set_uint_raw(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setUint", [{key, value}])
    quorum_send_transaction(data, options)
  end

  @spec delete_uint(term, keyword) :: :ok
  def delete_uint(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteUint", [{key}])
    transaction_via_queue(data, options)
  end

  @spec delete_uint_raw(term, keyword) :: :ok
  def delete_uint_raw(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteUint", [{key}])
    quorum_send_transaction(data, options)
  end

  @spec transfer_ownership(term, keyword) :: :ok
  def transfer_ownership(new_owner, options) do
    data = Contract.hash_data(:kimlic_context_storage, "transferOwnership", [{new_owner}])
    transaction_via_queue(data, options)
  end

  @spec transfer_ownership_raw(term, keyword) :: :ok
  def transfer_ownership_raw(new_owner, options) do
    data = Contract.hash_data(:kimlic_context_storage, "transferOwnership", [{new_owner}])
    quorum_send_transaction(data, options)
  end

  @spec delete_string(term, keyword) :: :ok
  def delete_string(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteString", [{key}])
    transaction_via_queue(data, options)
  end

  @spec delete_string_raw(term, keyword) :: :ok
  def delete_string_raw(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteString", [{key}])
    quorum_send_transaction(data, options)
  end

  @spec set_context(term, keyword) :: :ok
  def set_context(context, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setContext", [{context}])
    transaction_via_queue(data, options)
  end

  @spec set_context_raw(term, keyword) :: :ok
  def set_context_raw(context, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setContext", [{context}])
    quorum_send_transaction(data, options)
  end

  @spec get_context(keyword) :: {:ok, binary}
  def get_context(options) do
    data = Contract.hash_data(:kimlic_context_storage, "getContext", [{}])
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
