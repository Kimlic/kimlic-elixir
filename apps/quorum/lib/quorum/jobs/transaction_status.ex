defmodule Quorum.Jobs.TransactionStatus do
  @moduledoc false

  use TaskBunny.Job
  alias Log

  @quorum_client Application.get_env(:quorum, :client)

  @spec perform(map) :: :ok | :retry | {:error, term}
  def perform(%{"transaction_hash" => transaction_hash, "callback" => callback} = message) do
    case @quorum_client.eth_get_transaction_receipt(transaction_hash, []) do
      {:ok, status} when is_map(status) ->
        maybe_callback(callback, status, fetch_return_value(transaction_hash, message))

      {:ok, _} ->
        :retry

      err ->
        Log.error("Quorum.sendTransaction failed: #{inspect(err)}")
        err
    end
  end

  @spec max_retry :: integer
  def max_retry, do: 5

  @spec retry_interval(integer) :: integer
  def retry_interval(failed_count) do
    [1, 10, 20, 40, 60]
    |> Enum.map(&(&1 * 1000))
    |> Enum.at(failed_count - 1, 1000)
  end

  @spec fetch_return_value(binary, map) :: atom
  defp fetch_return_value(transaction_hash, %{"provide_return_value" => _}),
    do: do_fetch_return_value(transaction_hash, 1)

  @spec fetch_return_value(term, term) :: atom
  defp fetch_return_value(_, _), do: :not_required

  @spec do_fetch_return_value(binary, integer) :: {:error, binary}
  defp do_fetch_return_value(_transaction_hash, 4), do: {:error, "failed_fetch_return_value"}

  @spec do_fetch_return_value(binary, integer) :: {:ok, binary}
  defp do_fetch_return_value(transaction_hash, attempt) do
    case @quorum_client.request("debug_traceTransaction", [transaction_hash], []) do
      {:ok, response} ->
        {:ok, Map.get(response, "returnValue")}

      {:error, err} ->
        Log.error("Cannot fetch returnValue from Quorum for transaction `#{transaction_hash}`. Error: #{inspect(err)}")
        :timer.sleep(50)
        do_fetch_return_value(transaction_hash, attempt + 1)
    end
  end

  @spec maybe_callback(map, map, term) :: atom
  defp maybe_callback(%{"m" => module, "f" => function, "a" => args}, status, return_value) do
    Kernel.apply(String.to_atom(module), String.to_atom(function), prepare_args(args, status, return_value))
    :ok
  end

  @spec maybe_callback(term, term, term) :: atom
  defp maybe_callback(_mfa, _status, _return_value), do: :ok

  @spec prepare_args(list, map, term) :: list
  defp prepare_args(args, transaction_status, :not_required), do: args ++ [transaction_status]
  defp prepare_args(args, transaction_status, return_value), do: args ++ [transaction_status, return_value]
end
