defmodule MobileApi.ConfigController do
  @moduledoc false

  use MobileApi, :controller
  alias Core.ConfigKeeper
  action_fallback(MobileApi.FallbackController)

  @spec get_config(Conn.t(), map) :: Conn.t()
  def get_config(conn, _params) do
    json(conn, ConfigKeeper.all())
  end
end
