defmodule MobileApi.VerificationController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Verifications
  alias MobileApi.FallbackController
  alias MobileApi.Plugs.RequestValidator
  alias MobileApi.Validators.Verification.{ApproveValidator, EmailValidator, PhoneValidator}
  alias Plug.Conn

  action_fallback(FallbackController)

  plug(
    RequestValidator,
    [validator: ApproveValidator, error_handler: FallbackController] when action in ~w(verify_email verify_phone)a
  )

  plug(
    RequestValidator,
    [validator: EmailValidator, error_handler: FallbackController] when action == :create_email_verification
  )

  plug(
    RequestValidator,
    [validator: PhoneValidator, error_handler: FallbackController] when action == :create_phone_verification
  )

  # todo: validate request
  @spec create_email_verification(Conn.t(), map) :: Conn.t()
  def create_email_verification(conn, params) do
    account_address = conn.assigns.account_address

    with {:ok, _} <- Verifications.create_email_verification(params["email"], account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end

  # todo: validate request
  @spec verify_email(Conn.t(), map) :: Conn.t()
  def verify_email(conn, params) do
    with :ok <- Verifications.verify(:email, conn.assigns.account_address, params["code"]) do
      json(conn, %{status: "ok"})
    end
  end

  # todo: validate request
  @spec create_phone_verification(Conn.t(), map) :: Conn.t()
  def create_phone_verification(conn, params) do
    account_address = conn.assigns.account_address

    with {:ok, _} <- Verifications.create_phone_verification(params["phone"], account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end

  # todo: validate request
  @spec verify_phone(Conn.t(), map) :: Conn.t()
  def verify_phone(conn, params) do
    with :ok <- Verifications.verify(:phone, conn.assigns.account_address, params["code"]) do
      json(conn, %{status: "ok"})
    end
  end
end
