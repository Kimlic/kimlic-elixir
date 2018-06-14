defmodule MobileApi.DigitalVerificationController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Verifications.DigitalVerifications
  alias Core.Verifications.VerificationVendors

  action_fallback(MobileApi.FallbackController)

  # todo: validate request, (validate timestamp to be less than hour ago)
  @spec create_session(Conn.t(), map) :: Conn.t()
  def create_session(conn, %{"vendor_id" => _} = params) do
    account_address = get_account_address(conn)

    with {:ok, session_id} <- DigitalVerifications.create_session(account_address, params) do
      json(conn, %{session_id: session_id})
    end
  end

  @spec get_vendors(Conn.t(), map) :: Conn.t()
  def get_vendors(conn, _params) do
    json(conn, VerificationVendors.all())
  end
end
