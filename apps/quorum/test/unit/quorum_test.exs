defmodule Unit.QuorumTest do
  use ExUnit.Case
  doctest Quorum

  alias Quorum.AMQP.Producer

  test "put data into queue" do
    assert :ok == Producer.publish(%{example: true})
  end
end
