defmodule MobileApi.Services.HeaderResolver do
  @moduledoc false

  alias Plug.Conn

  @spec get_account_address(Plug.Conn.t()) :: binary | nil
  def get_account_address(conn) do
    case Conn.get_req_header(conn, "account-address") do
      [value] -> value
      _ -> nil
    end
  end
end
