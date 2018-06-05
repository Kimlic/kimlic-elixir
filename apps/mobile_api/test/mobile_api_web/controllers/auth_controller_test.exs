defmodule MobileApi.AuthTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  import Core.Factory, only: [insert: 3]
  import MobileApi.RequestDataFactory
  import Mox

  alias Core.Clients.Redis
  alias Core.StorageKeys
  alias Core.Verifications.Verification
  alias Core.Verifications.TokenGenerator

  @moduletag :authorized

  @entity_type_email Verification.entity_type(:email)
  @entity_type_phone Verification.entity_type(:phone)

  describe "create profile" do
    test "success", %{conn: conn} do
      account_address = generate_account_address()
      token = TokenGenerator.generate(:email)
      email = "test#{token}@email.com"

      expect(TokenGeneratorMock, :generate, fn :email -> token end)

      assert %{status: 201} =
               post(conn, auth_path(conn, :create_profile), data_for(:auth_create_profile, email, account_address))

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_email}} =
               Redis.get(StorageKeys.vefirication_email(account_address))
    end
  end

  describe "check email verification" do
    test "success", %{conn: conn} do
      account_address = generate_account_address()
      token = TokenGenerator.generate(:email)
      verification_key = StorageKeys.vefirication_email(account_address)
      insert(:verification, verification_key, %{account_address: account_address, token: token})

      assert %{"status" => "ok"} =
               post(conn, auth_path(conn, :check_email_verification), %{
                 "token" => token,
                 "account_address" => account_address
               })
               |> json_response(200)
    end

    test "not found on email verification", %{conn: conn} do
      assert conn
             |> post(auth_path(conn, :check_email_verification), %{"token" => TokenGenerator.generate(:email)})
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

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_phone}} =
               Redis.get(StorageKeys.vefirication_phone(account_address))
    end

    test "with limited requests", %{conn: conn} do
      phone = generate_phone()
      account_address = generate_account_address()
      token = TokenGenerator.generate(:phone)

      attempts = Confex.fetch_env!(:mobile_api, :rate_limit_create_phone_verification_attempts)

      do_request = fn ->
        post(
          conn,
          auth_path(conn, :create_phone_verification),
          data_for(:auth_create_phone_verification, account_address, phone)
        )
      end

      expect(TokenGeneratorMock, :generate, attempts, fn :phone -> token end)
      expect(MessengerMock, :send, attempts, fn ^phone, _message -> {:ok, %{}} end)

      for _ <- 1..attempts, do: assert(%{status: 201} = do_request.())

      # rate limited requests
      for _ <- 1..10, do: assert(%{status: 429} = do_request.())
    end
  end

  describe "check phone verification" do
    test "success", %{conn: conn} do
      account_address = generate_account_address()
      code = TokenGenerator.generate(:phone)
      verification_key = StorageKeys.vefirication_phone(account_address)

      insert(:verification, verification_key, %{
        account_address: account_address,
        token: code,
        entity_type: @entity_type_phone
      })

      assert %{"status" => "ok"} =
               conn
               |> post(auth_path(conn, :check_phone_verification), %{
                 "code" => code,
                 "account_address" => account_address
               })
               |> json_response(200)
    end

    test "not found on phone verification", %{conn: conn} do
      request_data = %{"code" => TokenGenerator.generate(:phone), "account_address" => generate_account_address()}

      assert conn
             |> post(auth_path(conn, :check_phone_verification), request_data)
             |> json_response(404)
    end
  end

  @spec generate_phone :: binary
  defp generate_phone, do: "+38097#{Enum.random(1_000_000..9_999_999)}"

  @spec generate_account_address :: binary
  defp generate_account_address, do: "0xf" <> (:md5 |> :crypto.hash(TokenGenerator.generate(:email)) |> Base.encode16())
end
