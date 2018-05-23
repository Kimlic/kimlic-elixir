defmodule MobileApi.AuthController do
  @moduledoc false

  use MobileApi, :controller

  @spec create_profile(Conn.t(), %{}) :: Conn.t()
  def create_profile(conn, _params) do
    conn
  end
end
