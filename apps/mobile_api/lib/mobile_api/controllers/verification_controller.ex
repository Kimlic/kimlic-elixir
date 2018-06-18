defmodule MobileApi.VerificationController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Verifications
  alias Plug.Conn

  action_fallback(MobileApi.FallbackController)

  # todo: validate request
  @spec create_email_verification(Conn.t(), map) :: Conn.t()
  def create_email_verification(conn, params) do
    email = get_in(params, ["source_data", "email"])

    with :ok <- Verifications.create_email_verification(email, conn.assigns.account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end

  # todo: validate request
  @spec verify_email(Conn.t(), map) :: Conn.t()
  def verify_email(conn, params) do
    with :ok <- Verifications.verify(:email, conn.assigns.account_address, params["token"]) do
      json(conn, %{status: "ok"})
    end
  end

  # todo: validate request
  @spec create_phone_verification(Conn.t(), map) :: Conn.t()
  def create_phone_verification(conn, params) do
    phone = get_in(params, ["source_data", "phone"])

    with :ok <- Verifications.create_phone_verification(phone, conn.assigns.account_address) do
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
