defmodule MobileApi.ConfigController do
  @moduledoc false

  use MobileApi, :controller
  alias Quorum.Contract.Context

  action_fallback(MobileApi.FallbackController)

  @spec get_config(Conn.t(), map) :: Conn.t()
  def get_config(conn, _params) do
    json(conn, %{"context_contract" => Context.get_context_address()})
  end
end
