defmodule FidoQrCode do
  @moduledoc """
  Example of rendering QR Code in Phoenix Controller

  def qrcode(conn, _params) do
    conn
    |> put_resp_content_type("image/png")
    |> send_resp(201, FidoQrCode.generate())
  end
  """

  def generate do
    QRCode.to_png("http://test.example.com/qr_code?asd=123")
  end
end
