defmodule MobileApi.ConfigControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true
  import Mox

  @moduletag :authorized
  @moduletag :account_address

  describe "get config" do
    test "success", %{conn: conn} do
      address = generate(:account_address)

      expect(QuorumClientMock, :eth_call, fn _params, _block, _opts ->
        {:ok, address}
      end)

      assert %{"data" => %{"context_contract" => ^address}} =
               conn
               |> get(config_path(conn, :get_config))
               |> json_response(200)
    end
  end
end
