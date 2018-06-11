defmodule MobileApi.ConfigControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  alias Core.ContractAddresses

  describe "set contracts addresses" do
    test "success", %{conn: conn} do
      address = generate(:account_address)
      request_params = %{"VerificationContractFactory" => address}

      assert %{status: 200} = post(conn, config_path(conn, :set_contracts_addresses), request_params)
      assert ContractAddresses.get("VerificationContractFactory") == address
    end
  end
end
