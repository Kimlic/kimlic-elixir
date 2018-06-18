defmodule Quorum.Proxy.ClientBehaviour do
  @moduledoc false

  @callback call_rpc(map) :: {:ok, map} | {:error, map}
end
