defmodule Quorum.Contract.Generated.VerificationContractFactory do
  @moduledoc false

  use Quorum.Contract, :verification_contract_factory

  eth_call("getVerificationContract", [key])
  call_function("createBaseVerificationContract", [account, attestation_party_address, key, account_field_name])
end