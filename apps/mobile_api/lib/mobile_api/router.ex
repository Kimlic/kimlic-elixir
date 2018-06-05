defmodule MobileApi.Router do
  @moduledoc false

  use MobileApi, :router
  use Plug.ErrorHandler

  alias Plug.LoggerJSON
  alias MobileApi.Plugs.CreatePhoneVerificationLimiter

  require Logger

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :create_phone_verification_limiter do
    plug(CreatePhoneVerificationLimiter)
  end

  scope "/api", MobileApi do
    pipe_through(:api)

    post("/auth/create-profile", AuthController, :create_profile)
    post("/auth/check-email-verification", AuthController, :check_email_verification)
    post("/auth/check-phone-verification", AuthController, :check_phone_verification)

    scope "/auth/create-phone-verification" do
      pipe_through(:create_phone_verification_limiter)

      post("/", AuthController, :create_phone_verification)
    end
  end

  defp handle_errors(%Plug.Conn{status: 500} = conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    LoggerJSON.log_error(kind, reason, stacktrace)

    Logger.log(:info, fn ->
      Jason.encode!(%{
        "log_type" => "error",
        "request_params" => conn.params,
        "request_id" => Logger.metadata()[:request_id]
      })
    end)

    send_resp(conn, 500, Jason.encode!(%{errors: %{detail: "Internal server error"}}))
  end

  defp handle_errors(_, _), do: nil
end
