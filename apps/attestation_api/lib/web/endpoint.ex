defmodule AttestationApi.Endpoint do
  use Phoenix.Endpoint, otp_app: :attestation_api

  alias Confex.Resolver

  plug(Plug.RequestId)
  plug(Plug.LoggerJSON, level: Logger.level())

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(AttestationApi.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  @spec init(term, term) :: {:ok, Keyword.t()}
  def init(_key, config) do
    config = Resolver.resolve!(config)

    unless config[:secret_key_base] do
      raise "Set SECRET_KEY environment variable!"
    end

    {:ok, config}
  end
end
