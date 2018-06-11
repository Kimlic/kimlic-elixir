defmodule MobileApi.ConfigController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.ContractAddresses

  action_fallback(MobileApi.FallbackController)

  @spec set_contracts_addresses(Conn.t(), map) :: Conn.t()
  def set_contracts_addresses(conn, params) do
    with :ok <- ContractAddresses.set_batch(params) do
      json(conn, 200)
    end
  end
end
