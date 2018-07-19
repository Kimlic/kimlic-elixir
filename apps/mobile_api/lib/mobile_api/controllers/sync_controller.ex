defmodule MobileApi.SyncController do
  @moduledoc false

  use MobileApi, :controller
  alias Core.Sync

  action_fallback(MobileApi.FallbackController)

  @spec sync_profile(Conn.t(), map) :: Conn.t()
  def sync_profile(conn, _params) do
    sync_data = Sync.handle(conn.assigns.account_address)

    json(conn, %{"data_fields" => sync_data})
  end
end
