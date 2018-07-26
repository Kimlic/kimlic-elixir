defmodule MobileApi.ConfigController do
  @moduledoc false

  use MobileApi, :controller
  alias Core.ExternalConfig
  action_fallback(MobileApi.FallbackController)

  @spec get_config(Conn.t(), map) :: Conn.t()
  def get_config(conn, _params) do
    json(conn, ExternalConfig.all())
  end
end
