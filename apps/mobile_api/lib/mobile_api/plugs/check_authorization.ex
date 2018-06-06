defmodule MobileApi.Plugs.CheckAuthorization do
  @moduledoc false

  import Plug.Conn

  alias Plug.Conn
  alias Quorum.BearerService

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{} = conn, _opts) do
    with ["Bearer: " <> bearer_token] <- get_req_header(conn, "authorization"),
         [auth_secret_token] <- get_req_header(conn, "auth-secret-token"),
         true <- BearerService.authorized?(bearer_token, auth_secret_token) do
      conn
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> halt()
    end
  end
end
