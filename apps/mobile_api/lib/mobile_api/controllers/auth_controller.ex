defmodule MobileApi.AuthController do
  @moduledoc false

  use MobileApi, :controller

  alias Core.Auth

  @spec create_profile(Conn.t(), %{}) :: Conn.t()
  def create_profile(conn, %{
        "user_profile" => %{
          "source_data" => %{"email" => email},
          "blockchain_data" => %{"account_address" => account_address}
        }
      }) do
    with :ok <- Auth.create_profile(email, account_address) do
      conn
      |> put_status(201)
      |> json(%{})
    end
  end
end
