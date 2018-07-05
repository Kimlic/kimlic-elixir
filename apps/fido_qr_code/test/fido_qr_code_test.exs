defmodule FidoQrCodeTest do
  use ExUnit.Case
  alias FidoQrCode.ScopeRequest
  doctest FidoQrCode

  describe "generate qr code and process it" do
    test "happy path" do
      # 1. Create ScopeRequest with predefined scopes
      assert {:ok, scope_request = %ScopeRequest{}} = FidoQrCode.create_scope_request()

      # 2. Generate QR Code from ScopeRequest
      # Mobile Application scan code and get one time url with ScopeRequest id.
      # By requesting url ScopeRequest will be processed
      assert FidoQrCode.generate_qr_code(scope_request)

      # 3. Process ScopeRequest after scanned code
      # Result of processing it's response with two fields
      #   scope_request - ScopeRequest
      #   fido - Fido UAF regRequest or authRequest
      assert {:ok, resp} = FidoQrCode.process_scope_request(scope_request, "test-username")

      assert Map.has_key?(resp, :fido)
      assert Map.has_key?(resp, :scope_request)
      assert %ScopeRequest{username: "test-username"} = resp.scope_request

      # ScopeRequest already processed
      assert {:error, :scope_request_already_processed} =
               FidoQrCode.process_scope_request(scope_request, "test")
    end
  end
end
