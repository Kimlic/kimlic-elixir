defmodule Quorum.Unit.ABITest do
  use ExUnit.Case
  alias Quorum.Contract
  alias Quorum.ABI.{TypeDecoder, TypeEncoder}

  test "encode string" do
    email = String.duplicate("1234567890", 6) <> "@example.com"
    hash = Contract.hash_data(:account_storage_adapter, "setAccountFieldMainData", [{"email", email}])

    assert "0xf5464ddf" <> File.read!("test/data/setAccountFieldMainData.txt") == hash
  end

  test "decode string" do
    email = String.duplicate("1234567890", 6) <> "@example.com"

    decoded =
      "test/data/setAccountFieldMainData.txt"
      |> File.read!()
      |> Base.decode16!(case: :lower)
      |> TypeDecoder.decode_raw([{:tuple, [:string, :string]}])

    assert [{"email", email}] == decoded
  end

  test "encode and decode string" do
    long_string = String.duplicate("1234567890", 20) <> "@example.com"
    input = [{"awesome", 99, long_string, true}]
    types = [{:tuple, [:string, {:uint, 32}, :string, :bool]}]

    encoded = TypeEncoder.encode_raw(input, types)
    assert is_binary(encoded)

    assert input == TypeDecoder.decode_raw(encoded, types)
  end
end
