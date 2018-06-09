defmodule Quorum.Proxy.ClientBehaviour do
  @callback call_rpc(map) :: {:ok, map} | {:error, map}
end
