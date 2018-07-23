defmodule MobileApi.PushControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true
  import Mox

  @moduletag :account_address

  describe "send push" do
    test "success", %{conn: conn} do
      expect(PushMock, :send, fn _message, _device_os, _device_token -> :ok end)

      assert %{"data" => %{}} =
               conn
               |> post(push_path(conn, :send_push), %{message: "Test message", device_os: "ios", device_token: "1234"})
               |> json_response(200)
    end

    test "validate device os", %{conn: conn} do
      assert conn
             |> post(push_path(conn, :send_push), %{message: "Test message", device_os: "linux", device_token: "1234"})
             |> json_response(422)
    end
  end
end
