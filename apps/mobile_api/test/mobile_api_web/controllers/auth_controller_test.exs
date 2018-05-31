defmodule MobileApi.AuthTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  import MobileApi.RequestDataFactory
  import Mox

  alias Core.Clients.Redis
  alias Core.Factory
  alias Core.StorageKeys
  alias Core.Verifications.Verification

  @entity_type_email Verification.entity_type(:email)
  @entity_type_phone Verification.entity_type(:phone)

  describe "create profile test" do
    test "success", %{conn: conn} do
      token1 = generate_code()
      token2 = generate_code()

      expect(TokenGeneratorMock, :generate_code, fn -> token1 end)
      expect(TokenGeneratorMock, :generate_code, fn -> token2 end)

      [
        {"0xd0a6e6c54dbc68db5db3a091b171a77407ff7ccf", "test@email.com", token1},
        {"0xf0a6e6c54dbc68db5db3a091b171a77407ff7ccd", "test2@email.com", token2}
      ]
      |> Enum.map(fn {account_address, email, token} ->
        assert %{status: 201} =
                 post(conn, auth_path(conn, :create_profile), data_for(:auth_create_profile, email, account_address))

        assert {:ok, %Verification{account_address: ^account_address, entity_type: @entity_type_email}} =
                 Redis.get(StorageKeys.vefirication_email(token))
      end)
    end
  end

  describe "check verification token test" do
    test "success", %{conn: conn} do
      token = generate_code()
      verification = Factory.verification!(%{token: token})
      Redis.set(StorageKeys.vefirication_email(token), verification)

      assert %{"status" => "ok"} =
               post(conn, auth_path(conn, :check_verification_token), %{"token" => token})
               |> json_response(200)
    end

    test "not found", %{conn: conn} do
      assert post(conn, auth_path(conn, :check_verification_token), %{"token" => generate_code()}) |> json_response(404)
    end
  end

  @tag :wip
  describe "create phone verification" do
    test "success", %{conn: conn} do
      token1 = generate_code()
      token2 = generate_code()

      expect(TokenGeneratorMock, :generate_code, fn -> token1 end)
      expect(TokenGeneratorMock, :generate_code, fn -> token2 end)

      [
        {"0xd0a6e6c54dbc68db5db3a091b171a77407ff7ccf", token1},
        {"0xf0a6e6c54dbc68db5db3a091b171a77407ff7ccd", token2}
      ]
      |> Enum.map(fn {account_address, token} ->
        assert %{status: 201} =
                 post(
                   conn,
                   auth_path(conn, :create_phone_verification),
                   data_for(:auth_create_phone_verification, account_address)
                 )

        assert {:ok, %Verification{account_address: ^account_address, entity_type: @entity_type_phone}} =
                 Redis.get(StorageKeys.vefirication_phone(token))
      end)
    end
  end

  @spec generate_code :: binary
  defp generate_code, do: Enum.random(100_000..999_999) |> to_string()
end
