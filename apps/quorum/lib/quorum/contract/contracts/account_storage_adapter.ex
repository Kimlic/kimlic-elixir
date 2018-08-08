defmodule Quorum.Contract.Generated.AccountStorageAdapter do
  @moduledoc false

  use Quorum.Contract, :account_storage_adapter

  eth_call("getFieldDetails", [account_address, account_field_name])
  eth_call("getFieldHistoryLength", [account_address, account_field_name])
  eth_call("getLastFieldVerificationContractAddress", [account_address, account_field_name])
end
