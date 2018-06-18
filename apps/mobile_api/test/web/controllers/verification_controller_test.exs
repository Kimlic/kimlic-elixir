defmodule MobileApi.VerificationControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: false

  import MobileApi.RequestDataFactory
  import Mox

  alias Core.Clients.Redis
  alias Core.ContractAddresses
  alias Core.Verifications
  alias Core.Verifications.TokenGenerator
  alias Core.Verifications.Verification

  @moduletag :authorized
  @moduletag :account_address

  @entity_type_email Verification.entity_type(:email)
  @entity_type_phone Verification.entity_type(:phone)

  setup do
    ContractAddresses.set_batch(%{"VerificationContractFactory" => generate(:account_address)})

    :ok
  end

  describe "create email verification" do
    test "success", %{conn: conn} do
      account_address = get_account_address(conn)
      token = TokenGenerator.generate(:email)
      email = "test#{token}@email.com"

      expect(TokenGeneratorMock, :generate, fn :email -> token end)

      assert %{"data" => %{}, "meta" => %{"code" => 201}} =
               conn
               |> post(
                 verification_path(conn, :create_email_verification),
                 data_for(:create_email_verification, email)
               )
               |> json_response(201)

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_email}} =
               Verifications.get(account_address, :email)
    end

    test "error on getting VerificationContractFactory", %{conn: conn} do
      Redis.flush()

      token = TokenGenerator.generate(:email)
      email = "test#{token}@email.com"

      expect(TokenGeneratorMock, :generate, fn :email -> token end)

      assert %{"error" => %{"type" => "internal_error", "message" => error_message}} =
               conn
               |> post(
                 verification_path(conn, :create_email_verification),
                 data_for(:create_email_verification, email)
               )
               |> json_response(500)

      assert true = String.contains?(error_message, "VerificationContractFactory")
    end
  end

  describe "verify email" do
    test "success", %{conn: conn} do
      account_address = get_account_address(conn)
      %{token: token} = insert(:verification, %{account_address: account_address})

      assert %{"data" => %{"status" => "ok"}} =
               conn
               |> post(verification_path(conn, :verify_email), %{"token" => token})
               |> json_response(200)
    end

    test "not found on email verification", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :verify_email), %{"token" => TokenGenerator.generate(:email)})
             |> json_response(404)
    end
  end

  describe "create phone verification" do
    test "success", %{conn: conn} do
      account_address = get_account_address(conn)
      phone = generate(:phone)
      token = TokenGenerator.generate(:phone)

      expect(TokenGeneratorMock, :generate, fn :phone -> token end)
      expect(MessengerMock, :send, fn ^phone, _message -> {:ok, %{}} end)

      assert %{status: 201} =
               post(
                 conn,
                 verification_path(conn, :create_phone_verification),
                 data_for(:create_phone_verification, phone)
               )

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_phone}} =
               Verifications.get(account_address, :phone)
    end

    test "with limited requests", %{conn: conn} do
      phone = generate(:phone)
      token = TokenGenerator.generate(:phone)

      attempts = Confex.fetch_env!(:mobile_api, :rate_limit_create_phone_verification_attempts)

      do_request = fn ->
        post(
          conn,
          verification_path(conn, :create_phone_verification),
          data_for(:create_phone_verification, phone)
        )
      end

      expect(TokenGeneratorMock, :generate, attempts, fn :phone -> token end)
      expect(MessengerMock, :send, attempts, fn ^phone, _message -> {:ok, %{}} end)

      for _ <- 1..attempts, do: assert(%{status: 201} = do_request.())

      # rate limited requests
      for _ <- 1..10, do: assert(%{status: 429} = do_request.())
    end
  end

  describe "verify phone" do
    test "success", %{conn: conn} do
      account_address = get_account_address(conn)
      %{token: token} = insert(:verification, %{entity_type: @entity_type_phone, account_address: account_address})

      assert %{"data" => %{"status" => "ok"}} =
               conn
               |> post(verification_path(conn, :verify_phone), %{"code" => token})
               |> json_response(200)
    end

    test "not found on phone verification", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :verify_phone), %{"code" => TokenGenerator.generate(:phone)})
             |> json_response(404)
    end
  end

  @spec get_account_address(Plug.Conn.t()) :: binary
  defp get_account_address(%{assigns: %{account_address: account_address}}), do: account_address
end
