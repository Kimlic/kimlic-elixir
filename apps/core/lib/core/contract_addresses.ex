defmodule Core.ContractAddresses do
  @moduledoc false

  alias Core.Clients.Redis

  @spec get(binary) :: {:ok, binary} | {:error, binary}
  def get(contract_address), do: contract_address |> storage_key() |> Redis.get()

  @spec set_batch(map) :: :ok | {:error, binary}
  def set_batch(contracts_addresses) when is_map(contracts_addresses) do
    contracts_addresses
    |> Map.keys()
    |> Enum.map(&Redis.set(storage_key(&1), contracts_addresses[&1]))
    |> Enum.all?(&(&1 == :ok))
    |> case do
      true ->
        :ok

      _ ->
        Log.error("Fail to update contract addresses")
        {:error, "Fail to update contract addresses"}
    end
  end

  @spec storage_key(binary) :: binary
  defp storage_key(contract_address), do: "config:contract-address:#{contract_address}"
end
