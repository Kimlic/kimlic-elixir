defmodule CoreWeb.AuthTest do
  use CoreWeb.ConnCase, async: true
  alias Quorum

  test "test Quorum app" do
    assert Quorum.authenticated?("some_token")
  end
end
