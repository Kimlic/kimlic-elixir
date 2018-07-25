defmodule Quorum.Contracts.Generated.BaseVerificationBehaviour do
  @moduledoc false

  @callback tokens_unlock_at(keyword) :: {:ok, binary}

  @callback _status(keyword) :: {:ok, binary}

  @callback account_address(keyword) :: {:ok, binary}

  @callback renounce_ownership(keyword) :: :ok

  @callback verified_at(keyword) :: {:ok, binary}

  @callback owner(keyword) :: {:ok, binary}

  @callback account_field_name(keyword) :: {:ok, binary}

  @callback co_owner(keyword) :: {:ok, binary}

  @callback transfer_ownership(term, keyword) :: :ok

  @callback data_index(keyword) :: {:ok, binary}

  @callback reward_amount(keyword) :: {:ok, binary}

  @callback finalize_verification(term, keyword) :: :ok

  @callback get_data(keyword) :: {:ok, binary}

  @callback withdraw(keyword) :: :ok

  @callback get_status(keyword) :: {:ok, binary}

  @callback get_status_name(keyword) :: {:ok, binary}
end
