defmodule MobileApi.Router do
  @moduledoc false

  use MobileApi, :router
  use Plug.ErrorHandler

  alias MobileApi.Plugs.CheckAuthorization
  alias MobileApi.Plugs.CreatePhoneVerificationLimiter
  alias Plug.LoggerJSON

  require Logger

  ### Pipelines

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authorized do
    plug(CheckAuthorization)
  end

  pipeline :eview_response do
    plug(EView)
  end

  pipeline :create_phone_verification_limiter do
    plug(CreatePhoneVerificationLimiter)
  end

  ### Endpoints

  scope "/api", MobileApi do
    pipe_through([:api, :authorized, :eview_response])

    scope "/auth" do
      post("/email/send-verification", AuthController, :create_email_verification)
      post("/email/verify", AuthController, :verify_email)

      scope "/phone" do
        pipe_through(:create_phone_verification_limiter)
        post("/send-verification", AuthController, :create_phone_verification)
      end

      post("/phone/verify", AuthController, :verify_phone)
    end
  end

  scope "/api", MobileApi do
    pipe_through([:api, :authorized])

    post("/quorum", QuorumController, :proxy)
  end

  scope "/config", MobileApi do
    pipe_through([:api])

    post("/contracts_addresses", ConfigController, :set_contracts_addresses)
  end

  @spec handle_errors(Plug.Conn.t(), map) :: Plug.Conn.t()
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
