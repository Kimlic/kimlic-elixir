defmodule Quorum.Contract.Generated.VerificationContractFactoryBehaviour do
  @moduledoc false

  @callback created_contracts(term, keyword) :: {:ok, binary}

  @callback get_verification_contract(term, keyword) :: {:ok, binary}

  @callback create_email_verification(term, term, term, keyword) :: :ok

  @callback create_phone_verification(term, term, term, keyword) :: :ok

  @callback create_document_verification(term, term, term, keyword) :: :ok

  @callback create_base_verification_contract(term, term, term, term, keyword) :: :ok
end
