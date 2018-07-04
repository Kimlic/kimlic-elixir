defmodule MobileApi.VerificationControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: false

  import MobileApi.RequestDataFactory
  import Mox

  alias Core.Verifications
  alias Core.Verifications.TokenGenerator
  alias Core.Verifications.Verification

  @moduletag :authorized
  @moduletag :account_address

  @entity_type_email Verification.entity_type(:email)
  @entity_type_phone Verification.entity_type(:phone)

  defmodule QuorumContextExpect do
    defmacro __using__(_) do
      quote do
        # Quorum.getContext()
        # Quorum.getVerificationContractFactory()
        expect(QuorumClientMock, :eth_call, 2, fn params, _block, _opts ->
          assert Map.has_key?(params, :data)
          assert Map.has_key?(params, :to)
          {:ok, "0x111f4029f7e13575d5f4eab2c65ccc43b21aa67f4cfa200"}
        end)
      end
    end
  end

  setup do
    use QuorumContextExpect
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

      assert %{"data" => %{}, "meta" => %{"code" => 201}} =
               conn
               |> post(
                 verification_path(conn, :create_email_verification),
                 data_for(:create_email_verification, email)
               )
               |> json_response(201)

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_email}} =
               Verifications.get(:email, account_address)
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
               |> post(verification_path(conn, :approve_email), %{"code" => token})
               |> json_response(200)
    end

    test "cant access", %{conn: conn} do
      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      account_address = get_account_address(conn)
      %{token: token} = insert(:verification, %{account_address: account_address})

      assert %{"data" => %{"status" => "ok"}} =
               conn
               |> post(verification_path(conn, :approve_email), %{"code" => token})
               |> json_response(200)
    end

    test "not found on email verification", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :approve_email), %{"code" => TokenGenerator.generate(:email)})
             |> json_response(404)
      |> IO.inspect()
    end

    test "invalid params", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :approve_email), %{"code" => 123})
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

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      assert %{status: 201} =
               post(
                 conn,
                 verification_path(conn, :create_phone_verification),
                 data_for(:create_phone_verification, phone)
               )

      assert {:ok, %Verification{token: ^token, entity_type: @entity_type_phone}} =
               Verifications.get(:phone, account_address)
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

    test "fail to send sms", %{conn: conn} do
      phone = generate(:phone)
      error_message = "Fail to send sms"
      expect(TokenGeneratorMock, :generate, fn :phone -> TokenGenerator.generate(:phone) end)

      expect(MessengerMock, :send, fn ^phone, _message ->
        {:error, {:internal_error, error_message}}
      end)

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      assert %{"error" => %{"message" => ^error_message}} =
               conn
               |> post(
                 verification_path(conn, :create_phone_verification),
                 data_for(:create_phone_verification, phone)
               )
               |> json_response(500)
    end

    test "with limited requests", %{conn: conn} do
      attempts = Confex.fetch_env!(:mobile_api, :rate_limit_create_phone_verification_attempts)
      # Each attempt invoke 2 call to Quorum.Context. Minus 2 because of defined expect in setup macro
      # When requests will be cached - test will fail
      mock_calls = attempts * 2 - 2

      expect(QuorumClientMock, :eth_call, mock_calls, fn params, _block, _opts ->
        assert Map.has_key?(params, :data)
        assert Map.has_key?(params, :to)
        {:ok, "0x111f4029f7e13575d5f4eab2c65ccc43b21aa67f4cfa200"}
      end)

      phone = generate(:phone)
      token = TokenGenerator.generate(:phone)

      do_request = fn ->
        post(
          conn,
          verification_path(conn, :create_phone_verification),
          data_for(:create_phone_verification, phone)
        )
      end

      expect(TokenGeneratorMock, :generate, attempts, fn :phone -> token end)
      expect(MessengerMock, :send, attempts, fn ^phone, _message -> {:ok, %{}} end)

      expect(QuorumClientMock, :request, attempts, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

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
               |> post(verification_path(conn, :approve_phone), %{"code" => token})
               |> json_response(200)
    end

    test "not found on phone verification", %{conn: conn} do
      assert conn
             |> post(verification_path(conn, :approve_phone), %{"code" => TokenGenerator.generate(:phone)})
             |> json_response(404)
    end
  end
end
