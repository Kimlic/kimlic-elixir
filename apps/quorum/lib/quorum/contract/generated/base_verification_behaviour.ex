defmodule Quorum.Contracts.Generated.BaseVerificationBehaviour do
  @moduledoc false

  @callback tokens_unlock_at(keyword) :: {:ok, binary}

  @callback attestation_party(keyword) :: {:ok, binary}

  @callback account_address(keyword) :: {:ok, binary}

  @callback status(keyword) :: {:ok, binary}

  @callback renounce_ownership(keyword) :: :ok

  @callback verified_at(keyword) :: {:ok, binary}

  @callback owner(keyword) :: {:ok, binary}

  @callback account_field_name(keyword) :: {:ok, binary}

  @callback co_owner(keyword) :: {:ok, binary}

  @callback transfer_ownership(term, keyword) :: :ok

  @callback data_index(keyword) :: {:ok, binary}

  @callback set_verification_result(term, keyword) :: :ok

  @callback get_data(keyword) :: {:ok, binary}

  @callback withdraw(keyword) :: :ok
end
