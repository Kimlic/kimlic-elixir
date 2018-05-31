defmodule Quorum do
  @moduledoc """
  Documentation for Quorum.
  """

  alias Quorum.Jobs.{CreateUserAccount, CreateVerificationContract, UpdateUserAccount, TransactionCreate}

  def authenticated?(_token) do
    true
  end

  def create_user_account(params) do
    CreateUserAccount.enqueue!(params)
  end

  def create_verification_contract(params) do
    CreateVerificationContract.enqueue!(params)
  end

  def update_user_account(params) do
    UpdateUserAccount.enqueue!(params)
  end

  @spec create_transaction(map) :: :ok
  def create_transaction(transaction_data), do: do_create_transaction(transaction_data, nil)

  @spec create_transaction(map, {atom, atom, list}) :: :ok
  def create_transaction(transaction_data, {module, function, args})
      when is_atom(module) and is_atom(function) and is_list(args) do
    do_create_transaction(transaction_data, %{m: module, f: function, a: args})
  end

  defp do_create_transaction(transaction_data, callback) do
    TransactionCreate.enqueue!(%{transaction_data: transaction_data, callback: callback})
  end
end
