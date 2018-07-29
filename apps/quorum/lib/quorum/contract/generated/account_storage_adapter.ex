defmodule Quorum.Contract.Generated.AccountStorageAdapter do
  @moduledoc false

  @contract_client Application.get_env(:quorum, :contract_client)
  @contract_name :account_storage_adapter

  def get_field_history_length(account_address, account_field_name, options) when is_map(options) do
    @contract_client.eth_call(
      @contract_name,
      "getFieldHistoryLength",
      [{account_address, account_field_name}],
      options
    )
  end

  def get_last_field_verification_contract_address(account_address, account_field_name, options) when is_map(options) do
    @contract_client.eth_call(
      @contract_name,
      "getLastFieldVerificationContractAddress",
      [{account_address, account_field_name}],
      options
    )
  end
end
