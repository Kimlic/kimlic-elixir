defmodule AttestationApi.DigitalVerificationControllerTest do
  @moduledoc false

  use AttestationApi.ConnCase, async: false

  import AttestationApi.RequestDataFactory
  import Mox

  alias Ecto.UUID
  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.DigitalVerifications

  @moduletag :authorized
  @moduletag :account_address

  # kimlic id stored in verification_providers.json
  @vendor_id "87177897-2441-43af-a6bf-4860afcdd067"

  setup :set_mox_global

  describe "create session" do
    test "success", %{conn: conn} do
      request_data = data_for(:verification_digital_create_session)
      vendor_id = UUID.generate()
      session_id = UUID.generate()

      expect(VeriffmeMock, :create_session, fn _, _, _, _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: 201,
           body:
             %{
               "status" => "success",
               "verification" => %{
                 "id" => session_id,
                 "url" => "https://magic.veriff.me/v/",
                 "host" => "https://magic.veriff.me",
                 "status" => "created",
                 "sessionToken" => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
               }
             }
             |> Jason.encode!()
         }}
      end)

      assert %{"data" => %{"session_id" => ^session_id}} =
               conn
               |> post(digital_verification_path(conn, :create_session, vendor_id), request_data)
               |> json_response(200)
    end

    test "fail with veriffme", %{conn: conn} do
      request_data = data_for(:verification_digital_create_session)
      vendor_id = UUID.generate()

      expect(VeriffmeMock, :create_session, fn _, _, _, _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: 400,
           body:
             %{
               "status" => "fail",
               "code" => 1201,
               "error" => "Timestamp must not be older than one hour."
             }
             |> Jason.encode!()
         }}
      end)

      assert %{"error" => %{"message" => _, "type" => "internal_error"}} =
               conn
               |> post(digital_verification_path(conn, :create_session, vendor_id), request_data)
               |> json_response(504)
    end
  end

  describe "upload media" do
    test "success", %{conn: conn} do
      expect(VeriffmeMock, :upload_media, 3, fn _session_id, context, _image_base64, _unix_timestamp ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             %{
               "status" => "success",
               "image" => %{
                 "id" => UUID.generate(),
                 "name" => context
               },
               "url" => "https://api.veriff.me/v1/media/#{UUID.generate()}"
             }
             |> Jason.encode!()
         }}
      end)

      expect(VeriffmeMock, :close_session, fn session_id ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             %{
               "status" => "success",
               "verification" => %{
                 "id" => session_id,
                 "url" => "https://magic.veriff.me/v/..",
                 "host" => "https://magic.veriff.me",
                 "status" => "submitted"
               },
               "url" => "https://api.veriff.me/v1/media/#{UUID.generate()}"
             }
             |> Jason.encode!()
         }}
      end)

      session_id = UUID.generate()
      request_data = data_for(:digital_verification_upload_media)
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      assert %{"data" => %{"status" => "ok"}} =
               conn
               |> post(digital_verification_path(conn, :upload_media, @vendor_id, session_id), request_data)
               |> json_response(200)
    end

    test "fail to upload media", %{conn: conn} do
      expect(VeriffmeMock, :upload_media, 3, fn _session_id, _context, _image_base64, _unix_timestamp ->
        {:ok,
         %HTTPoison.Response{
           status_code: 400,
           body: "{\"status\":\"fail\",\"code\":\"1002\",\"error\":\"Query ID must be a valid UUID V4\"}"
         }}
      end)

      session_id = UUID.generate()
      request_data = data_for(:digital_verification_upload_media)
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      assert %{"error" => %{"type" => "internal_error", "message" => _}} =
               conn
               |> post(digital_verification_path(conn, :upload_media, @vendor_id, session_id), request_data)
               |> json_response(500)
    end

    test "fail to close veriffme session", %{conn: conn} do
      expect(VeriffmeMock, :upload_media, 3, fn _session_id, context, _image_base64, _unix_timestamp ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             %{
               "status" => "success",
               "image" => %{
                 "id" => UUID.generate(),
                 "name" => context
               },
               "url" => "https://api.veriff.me/v1/media/#{UUID.generate()}"
             }
             |> Jason.encode!()
         }}
      end)

      expect(VeriffmeMock, :close_session, fn _session_id ->
        {:ok,
         %HTTPoison.Response{
           status_code: 400,
           body: "{\"status\":\"fail\",\"code\":\"1002\",\"error\":\"Query ID must be a valid UUID V4\"}"
         }}
      end)

      session_id = UUID.generate()
      request_data = data_for(:digital_verification_upload_media)
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      assert %{"error" => %{"type" => "internal_error", "message" => _}} =
               conn
               |> post(digital_verification_path(conn, :upload_media, @vendor_id, session_id), request_data)
               |> json_response(500)
    end

    test "invalid session id", %{conn: conn} do
      session_id = UUID.generate()
      invalid_session_id = UUID.generate()
      request_data = data_for(:digital_verification_upload_media)
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: invalid_session_id})

      assert %{"error" => %{"type" => "not_found"}} =
               conn
               |> post(digital_verification_path(conn, :upload_media, @vendor_id, session_id), request_data)
               |> json_response(404)
    end

    test "invalid vendor id", %{conn: conn} do
      session_id = UUID.generate()
      invalid_vendor_id = UUID.generate()
      request_data = data_for(:digital_verification_upload_media)
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      assert %{"error" => %{"type" => "not_found"}} =
               conn
               |> post(digital_verification_path(conn, :upload_media, invalid_vendor_id, session_id), request_data)
               |> json_response(404)
    end
  end

  describe "verification result webhook" do
    test "verification approved", %{conn: conn} do
      session_id = UUID.generate()
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      request_data =
        data_for(:digital_verification_result_webhook, %{
          "verification" => %{
            "id" => session_id,
            "status" => "approved",
            "code" => 9001
          }
        })

      assert conn
             |> post(digital_verification_path(conn, :verification_result_webhook), request_data)
             |> json_response(200)

      status_passed = DigitalVerification.status(:passed)
      assert {:ok, %{status: ^status_passed}} = DigitalVerifications.get(session_id)
    end

    test "verification declined", %{conn: conn} do
      session_id = UUID.generate()
      fail_code = 9102
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      request_data =
        data_for(:digital_verification_result_webhook, %{
          "verification" => %{
            "id" => session_id,
            "status" => "declined",
            "code" => fail_code,
            "reason" => "Person has not been verified",
            "comment" => [
              %{
                "type" => "video_call_comment",
                "comment" => "Person is from Bangladesh",
                "timestamp" => "2018-05-19T08:30:25.597Z"
              }
            ]
          }
        })

      assert conn
             |> post(digital_verification_path(conn, :verification_result_webhook), request_data)
             |> json_response(200)

      status_failed = DigitalVerification.status(:failed)
      assert {:ok, %{status: ^status_failed, veriffme_code: ^fail_code}} = DigitalVerifications.get(session_id)
    end

    test "verification not found on second call", %{conn: conn} do
      session_id = UUID.generate()
      insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      request_data =
        data_for(:digital_verification_result_webhook, %{
          "verification" => %{
            "id" => session_id,
            "status" => "approved",
            "code" => 9001
          }
        })

      assert conn
             |> post(digital_verification_path(conn, :verification_result_webhook), request_data)
             |> json_response(200)

      assert conn
             |> post(digital_verification_path(conn, :verification_result_webhook), request_data)
             |> json_response(404)
    end
  end

  describe "get video verification vendors" do
    test "success", %{conn: conn} do
      assert %{"data" => %{"vendors" => [%{"id" => _, "description" => _, "documents" => _} | _]}} =
               conn
               |> get(digital_verification_path(conn, :get_vendors))
               |> json_response(200)
    end
  end
end