defmodule AttestationApi.Router do
  @moduledoc false

  use AttestationApi, :router
  use Plug.ErrorHandler

  alias AttestationApi.Plugs.CheckAuthorization
  alias AttestationApi.Plugs.FetchAccountAddress
  alias Plug.LoggerJSON

  require Logger

  ### Pipelines

  pipeline :api do
    plug(:accepts, ["json"])
    plug(FetchAccountAddress)
  end

  pipeline :authorized do
    plug(CheckAuthorization)
  end

  pipeline :eview_response do
    plug(EView)
  end

  pipeline :accepts_json do
    plug(:accepts, ["json"])
  end

  ### Endpoints

  scope "/api/verifications/digital", AttestationApi do
    pipe_through([:api, :authorized, :eview_response])

    post("/:vendor_id/sessions", DigitalVerificationController, :create_session)
    post("/:vendor_id/sessions/:session_id/media", DigitalVerificationController, :upload_media)

    get("/vendors", DigitalVerificationController, :get_vendors)
  end

  scope "/api", AttestationApi do
    pipe_through(:accepts_json)

    post("/verifications/digital/decision", DigitalVerificationController, :verification_result_webhook)
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

    send_resp(conn, 500, Jason.encode!("Internal server error"))
  end
end
