defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract
  alias Quorum.Jobs.TransactionCreate

  @behaviour Quorum.Behaviour

  @type callback :: nil | {module :: atom, function :: atom, args :: list}

  @spec authenticated?(binary) :: boolean
  def authenticated?(_token) do
    true
  end

  @spec create_verification_contract(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, verification_type, callback \\ nil)

  def create_verification_contract(account_address, :email, callback),
    do: create_verification_transaction(account_address, "createEmailVerification", callback)

  def create_verification_contract(account_address, :phone, callback),
    do: create_verification_transaction(account_address, "createPhoneVerification", callback)

  @spec create_verification_transaction(binary, binary, callback) :: :ok
  defp create_verification_transaction(account_address, contract_function, callback) do
    account_address_hex = parse_hex(account_address)

    data =
      :verification_factory
      |> contract()
      |> hash_data(contract_function, [account_address_hex])

    create_transaction(%{from: account_address_hex, data: data}, callback)
  end

  @spec create_transaction(map) :: :ok
  def create_transaction(transaction_data), do: do_create_transaction(transaction_data, nil)

  @spec create_transaction(map, nil) :: :ok
  def create_transaction(transaction_data, nil), do: do_create_transaction(transaction_data, nil)

  @spec create_transaction(map, {atom, atom, list}) :: :ok
  def create_transaction(transaction_data, {module, function, args})
      when is_atom(module) and is_atom(function) and is_list(args) do
    do_create_transaction(transaction_data, %{m: module, f: function, a: args})
  end

  defp do_create_transaction(transaction_data, callback) do
    TransactionCreate.enqueue!(%{transaction_data: transaction_data, callback: callback})
  end

  @spec parse_hex(binary) :: integer
  defp parse_hex("0x" <> address) do
    {address_hex, _} = Integer.parse(address, 16)
    address_hex
  end
end
