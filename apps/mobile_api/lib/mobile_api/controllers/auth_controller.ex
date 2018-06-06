defmodule MobileApi.AuthController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Auth

  action_fallback(MobileApi.FallbackController)

  # todo: validate request
  @spec create_email_verification(Conn.t(), map) :: Conn.t()
  def create_email_verification(conn, params) do
    email = get_in(params, ["source_data", "email"])
    account_address = get_in(params, ["blockchain_data", "account_address"])

    with :ok <- Auth.create_email_verification(email, account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end

  # todo: validate request
  @spec verify_email(Conn.t(), map) :: Conn.t()
  def verify_email(conn, params) do
    with :ok <- Auth.check_verification(:email, params["account_address"], params["token"]) do
      json(conn, %{status: "ok"})
    end
  end

  # todo: validate request
  @spec create_phone_verification(Conn.t(), map) :: Conn.t()
  def create_phone_verification(conn, params) do
    account_address = get_in(params, ["blockchain_data", "account_address"])
    phone = get_in(params, ["source_data", "phone"])

    with :ok <- Auth.create_phone_verification(phone, account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end

  # todo: validate request
  @spec verify_phone(Conn.t(), map) :: Conn.t()
  def verify_phone(conn, params) do
    with :ok <- Auth.check_verification(:phone, params["account_address"], params["code"]) do
      json(conn, %{status: "ok"})
    end
  end
end
