defmodule MobileApi.DigitalVerificationController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Verifications.DigitalVerifications
  alias Core.Verifications.VerificationVendors
  alias MobileApi.Plugs.RequestValidator
  alias Plug.Conn

  action_fallback(MobileApi.FallbackController)

  plug(RequestValidator, [validator: MobileApi.Requests.CreateSessionRequest] when action in [:create_session])

  @spec create_session(Conn.t(), map) :: Conn.t()
  def create_session(conn, %{"vendor_id" => _} = params) do
    with {:ok, session_id} <- DigitalVerifications.create_session(conn.assigns.account_address, params) do
      json(conn, %{session_id: session_id})
    end
  end

  @spec get_vendors(Conn.t(), map) :: Conn.t()
  def get_vendors(conn, _params) do
    json(conn, VerificationVendors.all())
  end
end
