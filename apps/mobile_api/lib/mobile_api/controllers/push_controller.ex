defmodule MobileApi.PushController do
  @moduledoc false

  use MobileApi, :controller

  alias MobileApi.FallbackController
  alias MobileApi.Plugs.RequestValidator
  alias MobileApi.Validators.Push.SendPushValidator
  alias Plug.Conn

  action_fallback(FallbackController)

  @push_client Application.get_env(:core, :dependencies)[:push]

  plug(RequestValidator, [validator: SendPushValidator, error_handler: FallbackController] when action == :send_push)

  @spec send_push(Conn.t(), map) :: Conn.t()
  def send_push(conn, %{"message" => message, "device_os" => device_os, "device_token" => device_token}) do
    with :ok <- @push_client.send(message, device_os, device_token) do
      json(conn, %{"status" => "ok"})
    end
  end
end
