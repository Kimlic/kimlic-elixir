defmodule Quorum.Contract.Generated.KimlicContextStorageBehaviour do
  @moduledoc false

  @callback delete_bytes32(term, keyword) :: :ok

  @callback delete_address(term, keyword) :: :ok

  @callback get_address(term, keyword) :: {:ok, binary}

  @callback delete_bool(term, keyword) :: :ok

  @callback set_int(term, term, keyword) :: :ok

  @callback set_bytes32(term, term, keyword) :: :ok

  @callback set_string(term, term, keyword) :: :ok

  @callback renounce_ownership(keyword) :: :ok

  @callback get_bool(term, keyword) :: {:ok, binary}

  @callback delete_int(term, keyword) :: :ok

  @callback owner(keyword) :: {:ok, binary}

  @callback get_string(term, keyword) :: {:ok, binary}

  @callback get_bytes32(term, keyword) :: {:ok, binary}

  @callback set_bool(term, term, keyword) :: :ok

  @callback get_uint(term, keyword) :: {:ok, binary}

  @callback set_address(term, term, keyword) :: :ok

  @callback get_int(term, keyword) :: {:ok, binary}

  @callback set_uint(term, term, keyword) :: :ok

  @callback delete_uint(term, keyword) :: :ok

  @callback transfer_ownership(term, keyword) :: :ok

  @callback delete_string(term, keyword) :: :ok

  @callback set_context(term, keyword) :: :ok

  @callback get_context(keyword) :: {:ok, binary}
end
