defmodule MobileApi.ConfigControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  alias Core.ContractAddresses

  @moduletag :account_address

  describe "set contracts addresses" do
    test "success", %{conn: conn} do
      address = generate(:account_address)
      request_params = %{"VerificationContractFactory" => address}

      assert %{status: 200} = post(conn, config_path(conn, :set_contracts_addresses), request_params)
      assert {:ok, ^address} = ContractAddresses.get("VerificationContractFactory")
    end
  end
end
