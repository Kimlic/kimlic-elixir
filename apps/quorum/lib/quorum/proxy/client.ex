defmodule Quorum.Proxy.Client do
  @moduledoc false

  alias Ethereumex.Config

  @spec call_rpc(map) :: {:ok, map} | {:error, map}
  def call_rpc(payload) do
    HTTPoison.post(
      Config.rpc_url(),
      Jason.encode!(payload),
      [{"Content-Type", "application/json"}],
      Config.http_options()
    )
  end
end
