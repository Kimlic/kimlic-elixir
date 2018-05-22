defmodule Core.Foundation.Clients.Redis.Behaviour do
  @moduledoc false

  @callback get(binary) :: {:ok, term} | {:error, binary}
  @callback set(binary, term, pos_integer | nil) :: {:ok, term} | {:error, binary}
  @callback del(binary) :: {:ok, term} | {:error, binary}
end
