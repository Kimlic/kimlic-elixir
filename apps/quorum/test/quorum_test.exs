defmodule QuorumTest do
  use ExUnit.Case
  doctest Quorum

  test "greets the world" do
    assert Quorum.authenticated?("some_token")
  end
end
