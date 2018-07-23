defmodule AttestationApi.DigitalVerificationController do
  @moduledoc false

  use AttestationApi, :controller

  alias AttestationApi.DigitalVerifications
  alias AttestationApi.DigitalVerifications.Operations.UploadMedia
  alias AttestationApi.Plugs.RequestValidator
  alias AttestationApi.Validators.CreateSessionValidator
  alias AttestationApi.Validators.UploadMediaValidator
  alias AttestationApi.VendorDocuments
  alias Plug.Conn

  action_fallback(AttestationApi.FallbackController)

  plug(RequestValidator, [validator: CreateSessionValidator] when action in [:create_session])
  plug(RequestValidator, [validator: UploadMediaValidator] when action in [:upload_media])

  @spec create_session(Conn.t(), map) :: Conn.t()
  def create_session(conn, params) do
    with {:ok, session_id} <- DigitalVerifications.create_session(conn.assigns.account_address, params) do
      json(conn, %{session_id: session_id})
    end
  end

  @spec upload_media(Conn.t(), map) :: Conn.t()
  def upload_media(conn, %{"session_id" => _} = params) do
    with :ok <- UploadMedia.handle(params) do
      json(conn, %{status: "ok"})
    end
  end

  @spec verification_submission_webhook(Conn.t(), map) :: Conn.t()
  def verification_submission_webhook(conn, params) do
    with :ok <- DigitalVerifications.handle_verification_submission(params) do
      json(conn, %{})
    end
  end

  @spec verification_result_webhook(Conn.t(), map) :: Conn.t()
  def verification_result_webhook(conn, params) do
    with :ok <- DigitalVerifications.handle_verification_result(params) do
      json(conn, %{})
    end
  end

  @spec get_vendors(Conn.t(), map) :: Conn.t()
  def get_vendors(conn, _params) do
    json(conn, VendorDocuments.all())
  end
end
