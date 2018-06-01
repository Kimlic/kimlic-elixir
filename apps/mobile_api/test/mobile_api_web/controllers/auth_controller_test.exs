defmodule MobileApi.AuthTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  import MobileApi.RequestDataFactory
  import Mox

  alias Core.Clients.Redis
  alias Core.Factory
  alias Core.StorageKeys
  alias Core.Verifications.Verification
  alias Core.Verifications.TokenGenerator

  @entity_type_email Verification.entity_type(:email)
  @entity_type_phone Verification.entity_type(:phone)

  describe "create profile test" do
    test "success", %{conn: conn} do
      account_address = generate_account_address()
      token = TokenGenerator.generate(:email)
      email = "test#{token}@email.com"

      expect(TokenGeneratorMock, :generate, fn :email -> token end)

      assert %{status: 201} =
               post(conn, auth_path(conn, :create_profile), data_for(:auth_create_profile, email, account_address))

      assert {:ok, %Verification{account_address: ^account_address, entity_type: @entity_type_email}} =
               Redis.get(StorageKeys.vefirication_email(token))
    end
  end

  describe "check verification token test" do
    test "success", %{conn: conn} do
      token = TokenGenerator.generate(:email)
      verification = Factory.verification!(%{token: token})
      Redis.set(StorageKeys.vefirication_email(token), verification)

      assert %{"status" => "ok"} =
               post(conn, auth_path(conn, :check_verification_token), %{"token" => token})
               |> json_response(200)
    end

    test "not found", %{conn: conn} do
      assert conn
             |> post(auth_path(conn, :check_verification_token), %{"token" => TokenGenerator.generate(:email)})
             |> json_response(404)
    end
  end

  describe "create phone verification" do
    test "success", %{conn: conn} do
      phone = generate_phone()
      token = TokenGenerator.generate(:phone)
      account_address = generate_account_address()

      expect(TokenGeneratorMock, :generate, fn :phone -> token end)
      expect(MessengerMock, :send, fn ^phone, _message -> {:ok, %{}} end)

      assert %{status: 201} =
               post(
                 conn,
                 auth_path(conn, :create_phone_verification),
                 data_for(:auth_create_phone_verification, account_address, phone)
               )

      assert {:ok, %Verification{account_address: ^account_address, entity_type: @entity_type_phone}} =
               Redis.get(StorageKeys.vefirication_phone(token))
    end
  end

  @spec generate_phone :: binary
  defp generate_phone, do: "+38097#{Enum.random(1_000_000..9_999_999)}"

  @spec generate_account_address :: binary
  defp generate_account_address, do: "0xf" <> (:md5 |> :crypto.hash(TokenGenerator.generate(:email)) |> Base.encode16())
end
