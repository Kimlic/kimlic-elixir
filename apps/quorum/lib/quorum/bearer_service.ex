defmodule Quorum.BearerService do
  @moduledoc false

  @spec authorized?(binary, binary) :: boolean
  def authorized?(request_bearer, auth_token), do: request_bearer == bearer(auth_token)

  @spec bearer(binary) :: binary
  def bearer(auth_token) do
    authorization_salt = Confex.fetch_env!(:quorum, :authorization_salt)

    :sha256
    |> :crypto.hash(auth_token <> authorization_salt)
    |> Base.encode16()
  end
end
