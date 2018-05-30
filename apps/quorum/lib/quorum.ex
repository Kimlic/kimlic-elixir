defmodule Quorum do
  @moduledoc """
  Documentation for Quorum.
  """

  alias Core.Jobs.{CreateUserAccount, CreateVerificationContract}
  alias Quorum.Jobs.{UpdateUserAccount}

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
end
