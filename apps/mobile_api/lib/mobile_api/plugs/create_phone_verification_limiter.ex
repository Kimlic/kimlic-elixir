defmodule MobileApi.Plugs.CreatePhoneVerificationLimiter do
  @moduledoc false

  import Plug.Conn
  alias Plug.Conn

  @timeout :timer.hours(24)
  @attempts 5

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{params: params} = conn, _opts) do
    account_address = get_in(params, ["blockchain_data", "account_address"])
    phone = get_in(params, ["source_data", "phone"])
    user_rate_limit_key = "create_phone_verification_limiter:#{account_address}:#{phone}"

    case Hammer.check_rate(user_rate_limit_key, @timeout, @attempts) do
      {:allow, _count} -> conn
      _ -> conn |> put_status(429) |> halt()
    end
  end
end
