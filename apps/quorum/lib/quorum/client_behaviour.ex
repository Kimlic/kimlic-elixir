defmodule Quorum.ClientBehaviour do
  @moduledoc false

  @callback create_user_account(params :: map) :: {:ok, result :: term} | {:error, reason :: term}
  @callback create_verification_contract(params :: map) :: {:ok, result :: term} | {:error, reason :: term}
  @callback update_user_account(params :: map) :: {:ok, result :: term} | {:error, reason :: term}
end
