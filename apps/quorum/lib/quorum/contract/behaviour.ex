defmodule Quorum.Contract.Behaviour do
  @moduledoc false

  @callback call_function(atom, string, keyword, map) :: {:ok, binary}
  @callback eth_call(atom, string, keyword, map) :: {:ok, binary}
end
