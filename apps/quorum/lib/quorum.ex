defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract
  alias Quorum.Jobs.TransactionCreate

  @behaviour Quorum.Behaviour

  @type callback :: nil | {module :: atom, function :: atom, args :: list}

  @spec create_verification_transaction(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, :email, callback),
    do: create_verification_transaction(account_address, "createEmailVerification", callback)

  @spec create_verification_transaction(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, :phone, callback),
    do: create_verification_transaction(account_address, "createPhoneVerification", callback)

  @spec create_verification_transaction(binary, binary, callback) :: :ok
  defp create_verification_transaction(account_address, contract_function, callback) do
    account_address_hex = parse_hex(account_address)

    data =
      :verification_factory
      |> contract()
      |> hash_data(contract_function, [account_address_hex])

    create_transaction(%{from: account_address_hex, data: data}, callback, true)
  end

  @spec create_transaction(map, {atom, atom, list}, boolean) :: :ok
  def create_transaction(transaction_data, {module, function, args}, provide_return_value)
      when is_atom(module) and is_atom(function) and is_list(args) do
    %{
      transaction_data: transaction_data,
      callback: %{m: module, f: function, a: args}
    }
    |> put_provide_return_value(provide_return_value)
    |> TransactionCreate.enqueue!()
  end

  @spec put_provide_return_value(map, map) :: map
  defp put_provide_return_value(message, true), do: Map.put(message, :provide_return_value, true)
  defp put_provide_return_value(message, _), do: message

  @spec parse_hex(binary) :: integer
  defp parse_hex("0x" <> address) do
    {address_hex, _} = Integer.parse(address, 16)
    address_hex
  end
end
