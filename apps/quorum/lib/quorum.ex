defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract
  alias Quorum.Jobs.TransactionCreate

  @behaviour Quorum.Behaviour

  def authenticated?(_token) do
    true
  end

  @spec create_user_account(map) :: :ok
  def create_user_account(_params) do
    # ToDo: write code
    # create_transaction()
  end

  @spec create_verification_contract(binary, atom, {atom, atom, list}) :: :ok
  def create_verification_contract(account_address, :email, {_module, _function, _args} = callback),
    do: create_verification_transaction(account_address, "createEmailVerification", callback)

  @spec create_verification_contract(binary, atom, {atom, atom, list}) :: :ok
  def create_verification_contract(account_address, :phone, {_module, _function, _args} = callback),
    do: create_verification_transaction(account_address, "createPhoneVerification", callback)

  defp create_verification_transaction(account_address, contract_function, callback) do
    data =
      :verification_factory
      |> contract()
      |> hash_data(contract_function, [account_address])

    create_transaction(%{from: account_address, data: data}, callback)
  end

  def update_user_account(_params) do
    # ToDo: write code
    # create_transaction()
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
end
