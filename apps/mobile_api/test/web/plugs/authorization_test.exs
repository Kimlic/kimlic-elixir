defmodule MobileApi.AuthorizationTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true
  import Plug.Conn

  alias Ecto.UUID
  alias MobileApi.Plugs.Authorization
  alias Quorum.BearerService

  describe "user unauthorized" do
    test "bearer is missing", %{conn: conn} do
      assert %{status: 401} =
               conn
               |> put_req_header("auth-secret-token", UUID.generate())
               |> Authorization.call([])
    end

    test "auth secret token is missing", %{conn: conn} do
      assert %{status: 401} =
               conn
               |> put_req_header("authorization", "Bearer: #{UUID.generate()}")
               |> Authorization.call([])
    end

    test "invalid credentials", %{conn: conn} do
      assert %{status: 401} =
               conn
               |> put_req_header("authorization", "Bearer: #{UUID.generate()}")
               |> put_req_header("auth-secret-token", UUID.generate())
               |> Authorization.call([])
    end
  end

  describe "user authorized" do
    test "success", %{conn: conn} do
      auth_secret_token = UUID.generate()
      bearer = BearerService.bearer(auth_secret_token)

      assert %{status: nil} =
               conn
               |> put_req_header("authorization", "Bearer: #{bearer}")
               |> put_req_header("auth-secret-token", auth_secret_token)
               |> Authorization.call([])
    end
  end
end