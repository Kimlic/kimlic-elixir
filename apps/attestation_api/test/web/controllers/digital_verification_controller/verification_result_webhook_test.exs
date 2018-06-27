defmodule AttestationApi.DigitalVerificationController.VerificationResultWebhookTest do
  @moduledoc false

  use AttestationApi.ConnCase, async: false

  import AttestationApi.RequestDataFactory

  alias AttestationApi.DigitalVerifications
  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.DigitalVerifications.DigitalVerificationDocument
  alias AttestationApi.Repo
  alias Ecto.UUID

  @moduletag :authorized
  @moduletag :account_address

  describe "verification result webhook" do
    test "verification approved", %{conn: conn} do
      session_id = UUID.generate()

      %{id: verification_id} =
        insert(:digital_verification, %{account_address: get_account_address(conn), session_id: session_id})

      insert(:digital_verification_document, %{verification_id: verification_id, context: "face"})
      insert(:digital_verification_document, %{verification_id: verification_id, context: "document-front"})
      insert(:digital_verification_document, %{verification_id: verification_id, context: "document-back"})

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
      assert %{status: ^status_passed} = DigitalVerifications.get(session_id)

      assert [] = Repo.all(DigitalVerificationDocument)
    end

    test "empty verification documents", %{conn: conn} do
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
      assert %{status: ^status_failed, veriffme_code: ^fail_code} = DigitalVerifications.get(session_id)
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
end
