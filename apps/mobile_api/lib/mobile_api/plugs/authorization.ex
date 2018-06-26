defmodule MobileApi.Plugs.Authorization do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller, only: [render: 3]

  alias EView.Views.Error
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
        |> render(Error, "401.json")
        |> halt()
    end
  end
end
