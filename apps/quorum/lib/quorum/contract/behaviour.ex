defmodule Quorum.Contract.Behaviour do
  @moduledoc false

  @callback call_function(atom, binary, keyword, map) :: {:ok, binary}
  @callback eth_call(atom, binary, keyword, map) :: {:ok, binary}
end
