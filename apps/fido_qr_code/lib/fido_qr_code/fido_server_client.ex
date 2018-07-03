defmodule FidoQrCode.FidoServerClient do
  use HTTPoison.Base
  alias FidoQrCode.ResponseDecoder

  def process_url(url), do: Confex.fetch_env!(:fido_qr_code, :fido_server_url) <> url

  def create_request(username) do
    # ToDo decide which request create by stored puyblic key in Fido Server
    create_reg_request(username)
  end

  def create_reg_request(username) do
    get!("/v1/public/regRequest/#{username}")
  end

  def create_auth_request do
    get!("/v1/public/uafAuthRequest")
  end

  def request!(method, url, body \\ "", headers \\ [], options \\ []) do
    method
    |> super(url, body, headers, options)
    |> ResponseDecoder.check_response()
  end
end
