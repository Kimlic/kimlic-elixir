defmodule MobileApi.Plugs.FetchAccountAddress do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]

  alias MobileApi.ErrorView
  alias Plug.Conn

  @header "account-address"
  @address_regex ~r/^0x[0-9a-f]{40}$/

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{} = conn, _opts) do
    with [account_address] <- Conn.get_req_header(conn, @header),
         true <- address_valid?(account_address) do
      assign(conn, :account_address, account_address)
    else
      _ ->
        conn
        |> put_status(422)
        |> render(ErrorView, "422.json", %{message: "Check account address header is present and valid"})
        |> halt()
    end
  end

  @spec address_valid?(binary) :: boolean
  def address_valid?(address), do: Regex.match?(@address_regex, address)
end
