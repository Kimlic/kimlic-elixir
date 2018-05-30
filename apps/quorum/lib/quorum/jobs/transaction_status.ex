defmodule Quorum.Jobs.TransactionStatus do
  use TaskBunny.Job
  require Logger

  @quorum_client Application.get_env(:quorum, :client)

  @spec perform(map) :: :ok
  def perform(%{"transaction_hash" => transaction_hash, "callback" => callback}) do
    case @quorum_client.eth_get_transaction_receipt(transaction_hash, []) do
      {:ok, status} when is_map(status) ->
        maybe_callback(callback, status)

      {:ok, _} ->
        :retry

      err ->
        Logger.error("Quorum.sendTransaction failed: #{inspect(err)}")
        err
    end
  end

  def max_retry, do: 5

  def retry_interval(failed_count) do
    [1, 10, 20, 40, 60]
    |> Enum.map(&(&1 * 1000))
    |> Enum.at(failed_count - 1, 1000)
  end

  defp maybe_callback(%{"m" => module, "f" => function, "a" => args}, status) do
    Kernel.apply(String.to_atom(module), String.to_atom(function), [status] ++ args)
    :ok
  end

  defp maybe_callback(_, _status), do: :ok
end
