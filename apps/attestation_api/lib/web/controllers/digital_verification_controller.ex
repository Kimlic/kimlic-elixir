defmodule AttestationApi.DigitalVerificationController do
  @moduledoc false

  use AttestationApi, :controller

  alias AttestationApi.DigitalVerifications
  alias AttestationApi.DigitalVerifications.VerificationVendors
  alias AttestationApi.Plugs.RequestValidator
  alias Plug.Conn

  action_fallback(AttestationApi.FallbackController)

  plug(RequestValidator, [validator: AttestationApi.Requests.CreateSessionRequest] when action in [:create_session])

  @spec create_session(Conn.t(), map) :: Conn.t()
  def create_session(conn, %{"vendor_id" => _} = params) do
    with {:ok, session_id} <- DigitalVerifications.create_session(conn.assigns.account_address, params) do
      json(conn, %{session_id: session_id})
    end
  end

  # todo: validate request
  @spec upload_media(Conn.t(), map) :: Conn.t()
  def upload_media(conn, %{"vendor_id" => _, "session_id" => _} = params) do
    with :ok <- DigitalVerifications.upload_media(conn.assigns.account_address, params) do
      json(conn, %{status: "ok"})
    end
  end

  # todo: validate request
  @spec verification_result_webhook(Conn.t(), map) :: Conn.t()
  def verification_result_webhook(conn, params) do
    with :ok <- DigitalVerifications.update_status(params) do
      json(conn, %{})
    end
  end

  @spec get_vendors(Conn.t(), map) :: Conn.t()
  def get_vendors(conn, _params) do
    json(conn, VerificationVendors.all())
  end
end
