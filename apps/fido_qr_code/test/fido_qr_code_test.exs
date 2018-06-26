defmodule FidoQrCodeTest do
  use ExUnit.Case
  doctest FidoQrCode

  test "generate qr code" do
    assert FidoQrCode.hello() == :world
  end
end
