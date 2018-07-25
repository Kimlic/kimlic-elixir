defmodule MobileApi.PushControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: false
  import Mox

  @moduletag :account_address

  setup :set_mox_global

  describe "send push" do
    test "success", %{conn: conn} do
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
