defmodule MobileApi.Plugs.PhoneVerificationLimiter do
  @moduledoc false

  import Plug.Conn
  alias Plug.Conn

  @too_many_requests_status 429

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{params: params} = conn, _opts) do
    account_address = get_in(params, ["blockchain_data", "account_address"])
    phone = get_in(params, ["source_data", "phone"])
    user_rate_limit_key = "create_phone_verification_limiter:#{account_address}:#{phone}"

    case Hammer.check_rate(user_rate_limit_key, timeout(), attempts()) do
      {:allow, _count} -> conn
      _ -> conn |> put_status(@too_many_requests_status) |> halt()
    end
  end

  @spec timeout :: integer
  defp timeout, do: Confex.fetch_env!(:mobile_api, :rate_limit_create_phone_verification_timeout)

  @spec attempts :: integer
  defp attempts, do: Confex.fetch_env!(:mobile_api, :rate_limit_create_phone_verification_attempts)
end
