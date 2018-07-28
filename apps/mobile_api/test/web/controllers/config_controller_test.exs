defmodule MobileApi.ConfigControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true
  import Mox

  @moduletag :account_address

  describe "get config" do
    test "success", %{conn: conn} do
      context_address = generate(:account_address)

      expect(KimlicContextStorageMock, :get_context, fn _ ->
        {:ok, context_address}
      end)

      assert %{"data" => %{"context_contract" => ^context_address}} =
               conn
               |> get(config_path(conn, :get_config))
               |> json_response(200)
    end
  end
end
