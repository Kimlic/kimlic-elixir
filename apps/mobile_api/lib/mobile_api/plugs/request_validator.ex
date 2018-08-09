defmodule MobileApi.Plugs.RequestValidator do
  @moduledoc false

  use Phoenix.Controller

  import Plug.Conn

  alias Ecto.Changeset
  alias MobileApi.FallbackController
  alias Plug.Conn

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{params: params} = conn, [{:validator, validator} | _] = opts) do
    case validator.changeset(params) do
      %Changeset{valid?: true} = changeset ->
        assign(conn, :validated_params, Changeset.apply_changes(changeset))

      %Changeset{valid?: false} = changeset ->
        err_handler = opts[:error_handler] || FallbackController

        conn
        |> err_handler.call(changeset)
        |> halt()
    end
  end
end
