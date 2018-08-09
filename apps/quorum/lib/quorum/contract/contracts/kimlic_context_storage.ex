defmodule Quorum.Contract.KimlicContextStorage do
  @moduledoc false

  use Quorum.Contract, :kimlic_context_storage

  eth_call("getContext", [])
end
