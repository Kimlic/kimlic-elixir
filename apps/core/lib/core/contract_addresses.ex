defmodule Core.ContractAddresses do
  @moduledoc false

  alias Core.Clients.Redis

  @storage_key "config:contract-addresses"

  @spec get(binary) :: binary | {:error, binary}
  def get(contract) do
    with {:ok, %{} = contracts} <- Redis.get(@storage_key) do
      Map.get(contracts, contract)
    end
  end

  @spec set(map) :: :ok | {:error, atom}
  def set(contracts_addresses) when is_map(contracts_addresses), do: Redis.set(@storage_key, contracts_addresses)
end
