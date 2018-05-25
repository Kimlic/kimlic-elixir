defmodule Unit.QueueTest do
  use ExUnit.Case
  doctest Quorum

  test "greets the world" do
    assert Quorum.authenticated?("test")
  end
end
