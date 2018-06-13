defmodule MobileApi.VerificationVideoController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Verifications.VerificationVendors

  action_fallback(MobileApi.FallbackController)

  @spec get_vendors(Conn.t(), map) :: Conn.t()
  def get_vendors(conn, _params) do
    json(conn, VerificationVendors.all())
  end
end
