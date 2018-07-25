defmodule Quorum.Contracts.Generated.AccountStorageAdapterBehaviour do
  @moduledoc false

  @callback renounce_ownership(keyword) :: :ok

  @callback owner(keyword) :: {:ok, binary}

  @callback transfer_ownership(term, keyword) :: :ok

  @callback add_allowed_field_name(term, keyword) :: :ok

  @callback remove_allowed_field_name(term, keyword) :: :ok

  @callback is_allowed_field_name(term, keyword) :: {:ok, binary}

  @callback set_field_main_data(term, term, keyword) :: :ok

  @callback get_field_details(term, term, keyword) :: {:ok, binary}

  @callback get_last_field_verification_contract_address(term, term, keyword) :: {:ok, binary}

  @callback get_field_verification_contract_address(term, term, term, keyword) :: {:ok, binary}

  @callback get_field_last_main_data(term, term, keyword) :: {:ok, binary}

  @callback get_field_main_data(term, term, term, keyword) :: {:ok, binary}

  @callback get_field_last_verification_data(term, term, keyword) :: {:ok, binary}

  @callback get_field_verification_data(term, term, term, keyword) :: {:ok, binary}

  @callback get_is_field_verification_contract_exist(term, term, term, keyword) :: {:ok, binary}

  @callback set_field_last_verification_contract_address(term, term, term, keyword) :: :ok

  @callback set_field_verification_contract_address(term, term, term, term, keyword) :: :ok

  @callback get_field_history_length(term, term, keyword) :: {:ok, binary}
end
