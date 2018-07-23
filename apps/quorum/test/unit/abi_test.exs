defmodule Quorum.Unit.ABITest do
  use ExUnit.Case
  alias Quorum.Contract

  test "encode string" do
    email = String.duplicate("1234567890", 6) <> "@example.com"
    hash = Contract.hash_data(:account_storage_adapter, "setAccountFieldMainData", [{"email", email}])

    assert "0xf5464ddf" <> File.read!("test/data/setAccountFieldMainData.txt") == hash
  end
end
