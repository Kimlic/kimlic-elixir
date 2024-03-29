defmodule MobileApi.SyncControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true
  import Mox

  @moduletag :account_address

  @hashed_true "0x0000000000000000000000000000000000000000000000000000000000000001"
  @hashed_false "0x0000000000000000000000000000000000000000000000000000000000000000"

  describe "sync test" do
    test "expect 2 fields returned: email, documents.id_card", %{conn: conn} do
      expected_verifications = ["email", "documents.id_card"]

      expect(QuorumClientMock, :request, fn method, _params, _opts ->
        assert "personal_unlockAccount" == method
        {:ok, true}
      end)

      expect(QuorumContractMock, :eth_call, fn :kimlic_context_storage, "getContext", _args, _opts ->
        {:ok, generate(:account_address)}
      end)

      expect(QuorumContractMock, :eth_call, fn :kimlic_contracts_context, "getAccountStorageAdapter", _args, _opts ->
        {:ok, generate(:account_address)}
      end)

      fields_count = Confex.fetch_env!(:core, :sync_fields) |> length()

      expect(QuorumContractMock, :eth_call, fields_count, fn :account_storage_adapter, function, [{_, field}], _opts ->
        assert "getFieldHistoryLength" == function

        cond do
          field in expected_verifications -> {:ok, @hashed_true}
          true -> {:ok, @hashed_false}
        end
      end)

      expect(QuorumContractMock, :eth_call, 2, fn :account_storage_adapter, function, _args, _opts ->
        assert "getFieldDetails" == function

        {:ok,
         "0x0000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004d7b22656d61696c223a202235313836343341373138323733443335413938423539334232413342433332304131413542413541433536453346374134323739343144454341424435423745227d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"}
      end)

      assert %{"data" => %{"data_fields" => data_fields}} =
               conn
               |> get(sync_path(conn, :sync_profile))
               |> json_response(200)

      assert 2 == length(data_fields)

      for %{"name" => name, "status" => _, "value" => _, "verification_contract" => _, "verified_on" => _} <-
            data_fields,
          do: assert(name in expected_verifications)
    end
  end
end
