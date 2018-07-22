defmodule Quorum.Contracts.Generated.KimlicContextStorage do
  @moduledoc false

  alias Quorum.Contract

  @behaviour Quorum.Contracts.Generated.KimlicContextStorageBehaviour

  @quorum_client Application.get_env(:quorum, :client)

  def delete_bytes32(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteBytes32", [{key}])

    create_transaction(data, options)
  end

  def delete_address(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteAddress", [{key}])

    create_transaction(data, options)
  end

  def get_address(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getAddress", [{key}])

    quorum_client_request(data, options)
  end

  def delete_bool(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteBool", [{key}])

    create_transaction(data, options)
  end

  def set_int(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setInt", [{key, value}])

    create_transaction(data, options)
  end

  def set_bytes32(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setBytes32", [{key, value}])

    create_transaction(data, options)
  end

  def set_string(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setString", [{key, value}])

    create_transaction(data, options)
  end

  def renounce_ownership(options) do
    data = Contract.hash_data(:kimlic_context_storage, "renounceOwnership", [{}])

    create_transaction(data, options)
  end

  def get_bool(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getBool", [{key}])

    quorum_client_request(data, options)
  end

  def delete_int(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteInt", [{key}])

    create_transaction(data, options)
  end

  def owner(options) do
    data = Contract.hash_data(:kimlic_context_storage, "owner", [{}])

    quorum_client_request(data, options)
  end

  def get_string(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getString", [{key}])

    quorum_client_request(data, options)
  end

  def get_bytes32(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getBytes32", [{key}])

    quorum_client_request(data, options)
  end

  def set_bool(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setBool", [{key, value}])

    create_transaction(data, options)
  end

  def get_uint(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getUint", [{key}])

    quorum_client_request(data, options)
  end

  def set_address(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setAddress", [{key, value}])

    create_transaction(data, options)
  end

  def get_int(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "getInt", [{key}])

    quorum_client_request(data, options)
  end

  def set_uint(key, value, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setUint", [{key, value}])

    create_transaction(data, options)
  end

  def delete_uint(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteUint", [{key}])

    create_transaction(data, options)
  end

  def transfer_ownership(newOwner, options) do
    data = Contract.hash_data(:kimlic_context_storage, "transferOwnership", [{newOwner}])

    create_transaction(data, options)
  end

  def delete_string(key, options) do
    data = Contract.hash_data(:kimlic_context_storage, "deleteString", [{key}])

    create_transaction(data, options)
  end

  def set_context(context, options) do
    data = Contract.hash_data(:kimlic_context_storage, "setContext", [{context}])

    create_transaction(data, options)
  end

  def get_context(options) do
    data = Contract.hash_data(:kimlic_context_storage, "getContext", [{}])

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
