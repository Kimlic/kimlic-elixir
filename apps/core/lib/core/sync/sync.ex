defmodule Core.Sync do
  @moduledoc false

  alias Quorum.ABI.FunctionSelector
  alias Quorum.ABI.TypeDecoder
  alias Quorum.Contract.Context

  @account_storage_adapter Application.get_env(:quorum, :contracts)[:account_storage_adapter]

  @spec handle(binary) :: [map]
  def handle(account_address) do
    account_storage_adapter_address = Context.get_account_storage_adapter_address()

    :core
    |> Confex.fetch_env!(:sync_fields)
    |> Enum.filter(
      &Kernel.==(
        Quorum.validate_account_field_exists_and_set(account_address, &1, account_storage_adapter_address),
        :ok
      )
    )
    |> Enum.reduce([], fn sync_field, acc ->
      with {:ok, {field_value, verification_status, verification_contract_address, verified_on}} <-
             get_field_details(account_address, sync_field, account_storage_adapter_address) do
        verification_contract_address = "0x" <> Base.encode16(verification_contract_address, case: :lower)

        [
          %{
            "name" => sync_field,
            "value" => field_value,
            "status" => verification_status,
            "verification_contract" => verification_contract_address,
            "verified_on" => to_timestamp(verified_on)
          }
        ] ++ acc
      else
        _ -> acc
      end
    end)
  end

  @spec get_field_details(binary, binary, binary) :: {:ok, tuple} | {:error, binary}
  defp get_field_details(account_address, sync_field, account_storage_addapter_address) do
    function_selector = %FunctionSelector{types: [{:tuple, [:string, {:uint, 8}, :address, {:uint, 256}]}]}

    field_details_response =
      @account_storage_adapter.get_field_details(
        account_address,
        sync_field,
        from: Confex.fetch_env!(:quorum, :user_address),
        to: account_storage_addapter_address
      )

    with {_, {:ok, "0x" <> field_details_response}} <- {:quorum_error, field_details_response},
         true <- field_details_response != "",
         [{_sha256, _status, _contract_address, _verified_on} = fields] <-
           field_details_response
           |> Base.decode16!(case: :lower)
           |> TypeDecoder.decode(function_selector) do
      {:ok, fields}
    else
      {:quorum_error, err} ->
        Log.error("[#{__MODULE__}] Fail to sync with error: #{inspect(err)}")
        {:error, "Fail to sync"}

      _ ->
        {:error, "Fail to sync"}
    end
  end

  @spec to_timestamp(integer) :: integer
  defp to_timestamp(timestamp), do: round(timestamp / 1_000_000_000)
end
