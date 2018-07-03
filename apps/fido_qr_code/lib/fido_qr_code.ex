defmodule FidoQrCode do
  @moduledoc """
  Example of rendering QR Code in Phoenix Controller

  def qrcode(conn, _params) do
    conn
    |> put_resp_content_type("image/png")
    |> send_resp(201, FidoQrCode.generate_qr_code(scope_request))
  end
  """

  import FidoQrCode.ScopeRequests

  alias FidoQrCode.{ScopeRequest, ScopeRequests, FidoServerClient}

  def create_scope_request do
    ScopeRequests.create(%{
      callback_url: "",
      scopes: fetch_scopes(),
      status: ScopeRequest.status(:new),
      used: false
    })
  end

  def process_scope_request(%ScopeRequest{id: id}, username),
    do: process_scope_request(id, username)

  def process_scope_request(id, username) when is_binary(username) do
    with scope_request <- ScopeRequests.get!(id),
         :ok <- check_processed(scope_request),
         :ok <- check_expired(scope_request),
         {:ok, processed_scope_request} <- process(scope_request, username),
         {:ok, fido} <- FidoServerClient.create_request(username) do
      {:ok,
       %{
         scope_request: processed_scope_request,
         fido: fido
       }}
    end
  end

  def generate_qr_code(%ScopeRequest{id: id}) do
    callback_url = Confex.fetch_env!(:fido_qr_code, :callback_url)
    QRCode.to_png(callback_url <> "?scope_request=#{id}}")
  end

  defp fetch_scopes do
    :fido_qr_code
    |> Confex.fetch_env!(:requested_scopes)
    |> Enum.join(" ")
  end
end
