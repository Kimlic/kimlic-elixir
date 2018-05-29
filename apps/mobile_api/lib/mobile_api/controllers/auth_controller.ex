defmodule MobileApi.AuthController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Auth

  action_fallback(MobileApi.FallbackController)

  # todo: validate request
  @spec create_profile(Conn.t(), %{}) :: Conn.t()
  def create_profile(conn, params) do
    email = get_in(params, ["source_data", "email"])
    account_address = get_in(params, ["blockchain_data", "account_address"])

    with :ok <- Auth.create_profile(email, account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end
end
