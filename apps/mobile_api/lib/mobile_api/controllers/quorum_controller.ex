defmodule MobileApi.QuorumController do
  use MobileApi, :controller

  action_fallback(MobileApi.FallbackController)

  alias HTTPoison.Response
  alias MobileApi.{FallbackController, JSONRPCValidator}
  alias MobileApi.Plugs.RequestValidator

  plug(RequestValidator, validator: JSONRPCValidator, error_handler: FallbackController)

  @spec proxy(Plug.Conn.t(), map) :: Plug.Conn.t()
  def proxy(conn, params) do
    case Quorum.Proxy.proxy(params) do
      {_, %Response{status_code: code, body: body}} ->
        conn
        |> put_status(code)
        |> json(Jason.decode!(body))

      err ->
        Log.error("Unexpected response from Quorum: #{inspect(err)}")
        {:error, {:internal_error, "Unexpected response from Quorum"}}
    end
  end
end
