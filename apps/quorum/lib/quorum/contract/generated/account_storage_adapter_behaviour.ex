defmodule Quorum.Contracts.Generated.AccountStorageAdapterBehaviour do
  @moduledoc false

  @callback renounce_ownership(keyword) :: :ok
  @callback owner(keyword) :: {:ok, binary}
  @callback transfer_ownership(term, keyword) :: :ok
  @callback add_allowed_column_name(term, keyword) :: :ok
  @callback remove_allowed_column_name(term, keyword) :: :ok
  @callback is_allowed_column_name(term, keyword) :: {:ok, binary}
  @callback set_account_field_main_data(term, term, keyword) :: :ok
  @callback get_last_account_data_verification_contract_address(term, term, keyword) :: {:ok, binary}
  @callback get_account_data_verification_contract_address(term, term, term, keyword) :: {:ok, binary}
  @callback get_account_field_last_main_data(term, term, keyword) :: {:ok, binary}
  @callback get_account_field_main_data(term, term, term, keyword) :: {:ok, binary}
  @callback get_account_field_last_verification_data(term, term, keyword) :: {:ok, binary}
  @callback get_account_field_verification_data(term, term, term, keyword) :: {:ok, binary}
  @callback set_account_field_verification_contract_address(term, term, term, keyword) :: :ok
  @callback set_account_field_verification_contract_address(term, term, term, term, keyword) :: :ok
  @callback get_field_history_length(term, term, keyword) :: {:ok, binary}
end
