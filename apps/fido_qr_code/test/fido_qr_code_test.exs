defmodule FidoQrCodeTest do
  use ExUnit.Case
  alias FidoQrCode.ScopeRequest
  doctest FidoQrCode

  describe "generate qr code and process it" do
    test "happy path" do
      assert {:ok, scope_request = %ScopeRequest{}} = FidoQrCode.create_scope_request()
      assert {:ok, resp} = FidoQrCode.process_scope_request(scope_request, "test-username")

      assert Map.has_key?(resp, :fido)
      assert Map.has_key?(resp, :scope_request)
      assert %ScopeRequest{username: "test-username"} = resp.scope_request

      assert FidoQrCode.generate_qr_code(resp.scope_request)

      assert {:error, :scope_request_already_processed} = FidoQrCode.process_scope_request(scope_request, "test")
    end
  end
end
