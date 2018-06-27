defmodule AttestationApi.DigitalVerificationController.GetVideoVendorsTest do
  @moduledoc false

  use AttestationApi.ConnCase, async: false

  @moduletag :authorized
  @moduletag :account_address

  describe "get video verification vendors" do
    test "success", %{conn: conn} do
      assert %{"data" => %{"vendors" => [%{"id" => _, "description" => _, "documents" => _} | _]}} =
               conn
               |> get(digital_verification_path(conn, :get_vendors))
               |> json_response(200)
    end
  end
end
