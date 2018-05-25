defmodule Quorum do
  @moduledoc """
  Documentation for Quorum.
  """

  alias Core.Jobs.{CreateUserAccount, CreateVerificationContract}

  def authenticated?(_token) do
    true
  end

  def create_user_account(params) do
    CreateUserAccount.enqueue!(params)
  end

  def create_verification_contract(params) do
    CreateVerificationContract.enqueue!(params)
  end
end
