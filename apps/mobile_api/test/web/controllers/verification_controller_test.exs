defmodule MobileApi.VerificationControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: false

  import Mox

  alias Core.Verifications
  alias Core.Verifications.TokenGenerator
  alias Core.Verifications.Verification

  @moduletag :authorized
  @moduletag :account_address

  @entity_type_email Verification.entity_type(:email)
  @entity_type_phone Verification.entity_type(:phone)

  setup do
    expect(QuorumClientMock, :eth_call, 2, fn params, _block, _opts ->
      assert Map.has_key?(params, :data)
      assert Map.has_key?(params, :to)
      {:ok, generate(:account_address)}
    end)

    :ok
  end

  describe "create email verification" do
    test "success", %{conn: conn} do
      account_address = get_account_address(conn)
      token = TokenGenerator.generate(:email)
      email = "test#{token}@email.com"

      expect(TokenGeneratorMock, :generate, fn :email -> token end)

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      # Quorum.getAccountStorageAdapter()
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x000000000000000000000000d37debc7b53d678788661c74c94f265b62a412ac"}
      end)

      # Quorum.getVerificationContractFactory()
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x000000000000000000000000d37debc7b53d678788661c74c94f265b62a412ac"}
      end)

      # Quorum.getFieldHistoryLength(account_address, email)
      # Check that Account field email is set
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x0000000000000000000000000000000000000000000000000000000000000001"}
      end)

      assert %{"data" => %{}, "meta" => %{"code" => 201}} =
               conn
               |> post(verification_path(conn, :create_email_verification), %{email: email})
               |> json_response(201)

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_email}} =
               Verifications.get(:email, account_address)
    end

    test "email not set for account", %{conn: conn} do
      token = TokenGenerator.generate(:email)
      email = "test#{token}@email.com"

      expect(TokenGeneratorMock, :generate, fn :email -> token end)

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      # Quorum.getFieldHistoryLength(account_address, email)
      # Check that Account field email is set
      # Response - email not set
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"}
      end)

      # Quorum.getAccountStorageAdapter()
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x000000000000000000000000d37debc7b53d678788661c74c94f265b62a412ac"}
      end)

      err_message =
        conn
        |> post(verification_path(conn, :create_email_verification), %{email: email})
        |> json_response(409)
        |> get_in(~w(error message))

      assert err_message =~ "Account.email"
    end

    test "email param not set", %{conn: conn} do
      assert [err] =
               conn
               |> post(verification_path(conn, :create_email_verification), %{not: :set})
               |> json_response(422)
               |> get_in(~w(error invalid))

      assert "$.email" == err["entry"]
    end

    test "invalid email", %{conn: conn} do
      assert [err] =
               conn
               |> post(verification_path(conn, :create_email_verification), %{email: "invalid.format.com"})
               |> json_response(422)
               |> get_in(~w(error invalid))

      assert "$.email" == err["entry"]
    end
  end

  describe "verify email" do
    test "success", %{conn: conn} do
      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      account_address = get_account_address(conn)
      %{token: token} = insert(:verification, %{account_address: account_address})

      assert %{"data" => %{"status" => "ok"}} =
               conn
               |> post(verification_path(conn, :verify_email), %{"code" => token})
               |> json_response(200)
    end

    test "not found on email verification", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :verify_email), %{"code" => TokenGenerator.generate(:email)})
             |> json_response(404)
    end

    test "invalid params", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :verify_email), %{"code" => 123})
             |> json_response(422)
    end
  end

  describe "create phone verification" do
    test "success", %{conn: conn} do
      account_address = get_account_address(conn)
      phone = generate(:phone)
      token = TokenGenerator.generate(:phone)

      expect(TokenGeneratorMock, :generate, fn :phone -> token end)
      expect(MessengerMock, :send, fn ^phone, _message -> {:ok, %{}} end)

      # Quorum.getAccountStorageAdapter()
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x000000000000000000000000d37debc7b53d678788661c74c94f265b62a412ac"}
      end)

      # Quorum.getVerificationContractFactory()
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x000000000000000000000000d37debc7b53d678788661c74c94f265b62a412ac"}
      end)

      # Quorum.getFieldHistoryLength(account_address, phone)
      # Check that Account field phone is set
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x0000000000000000000000000000000000000000000000000000000000000001"}
      end)

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      conn
      |> post(verification_path(conn, :create_phone_verification), %{phone: phone})
      |> json_response(201)

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_phone}} =
               Verifications.get(:phone, account_address)
    end

    test "Account.phone not set", %{conn: conn} do
      phone = generate(:phone)
      token = TokenGenerator.generate(:phone)

      expect(TokenGeneratorMock, :generate, fn :phone -> token end)
      expect(MessengerMock, :send, fn ^phone, _message -> {:ok, %{}} end)

      # Quorum.getFieldHistoryLength(account_address, phone)
      # Check that Account field phone is set
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"}
      end)

      # Quorum.getAccountStorageAdapter()
      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, {:ok, generate(:account_address)}}
      end)

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      err_message =
        conn
        |> post(verification_path(conn, :create_phone_verification), %{phone: phone})
        |> json_response(409)
        |> get_in(~w(error message))

      assert err_message =~ "Account.phone"
    end

    test "phone param not set", %{conn: conn} do
      assert [err] =
               conn
               |> post(verification_path(conn, :create_phone_verification), %{not: :set})
               |> json_response(422)
               |> get_in(~w(error invalid))

      assert "$.phone" == err["entry"]
    end

    test "invalid phone", %{conn: conn} do
      assert [err] =
               conn
               |> post(verification_path(conn, :create_phone_verification), %{phone: "000111222"})
               |> json_response(422)
               |> get_in(~w(error invalid))

      assert "$.phone" == err["entry"]
    end

    test "with limited requests", %{conn: conn} do
      attempts = Confex.fetch_env!(:mobile_api, :rate_limit_create_phone_verification_attempts)

      # Quorum.getContextAddress
      stub(QuorumClientMock, :eth_call, fn params, _block, _opts ->
        assert Map.has_key?(params, :data)
        assert Map.has_key?(params, :to)

        case params.data do
          "0xbbe78c1b" <> _ -> {:ok, "0x0000000000000000000000000000000000000000000000000000000000000001"}
          _ -> {:ok, generate(:account_address)}
        end
      end)

      phone = generate(:phone)
      token = TokenGenerator.generate(:phone)

      stub(TokenGeneratorMock, :generate, fn :phone -> token end)
      stub(MessengerMock, :send, fn ^phone, _message -> {:ok, %{}} end)

      stub(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      do_request = fn ->
        post(conn, verification_path(conn, :create_phone_verification), %{phone: phone})
      end

      for _ <- 1..attempts, do: assert(%{status: 201} = do_request.())

      # rate limited requests
      for _ <- 1..10, do: assert(%{status: 429} = do_request.())
    end
  end

  describe "verify phone" do
    test "success", %{conn: conn} do
      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

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
end
