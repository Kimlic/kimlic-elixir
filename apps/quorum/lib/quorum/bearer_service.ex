defmodule Quorum.BearerService do
  @moduledoc false

  @spec authorized?(binary, binary) :: boolean
  def authorized?(auth_token, key), do: auth_token == bearer(key)

  @spec bearer(binary) :: binary
  def bearer(auth_key) do
    authorization_salt = Confex.fetch_env!(:quorum, :authorization_salt)

    :sha256
    |> :crypto.hash(auth_key <> authorization_salt)
    |> Base.encode16()
  end
end
