defmodule MobileApi.DigitalVerificationControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  import MobileApi.RequestDataFactory
  import Mox

  alias Ecto.UUID

  @moduletag :authorized

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

  describe "get video verification vendors" do
    test "success", %{conn: conn} do
      assert %{"data" => %{"vendors" => [%{"id" => _, "description" => _, "documents" => _} | _]}} =
               conn
               |> get(digital_verification_path(conn, :get_vendors))
               |> json_response(200)
    end
  end
end
