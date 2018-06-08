defmodule Quorum.Jobs.TransactionCreate do
  use TaskBunny.Job
  alias Log
  alias Quorum.Jobs.TransactionStatus

  @quorum_client Application.get_env(:quorum, :client)

  @spec perform(map) :: :ok | {:error, term}
  def perform(%{"transaction_data" => transaction_data, "callback" => callback} = message) do
    case @quorum_client.eth_send_transaction(transaction_data, []) do
      {:ok, transaction_hash} ->
        %{
          transaction_hash: transaction_hash,
          callback: callback
        }
        |> put_provide_return_value(message)
        |> TransactionStatus.enqueue!()

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

  @spec put_provide_return_value(map, map) :: map
  defp put_provide_return_value(message, %{"provide_return_value" => _}),
    do: Map.put(message, :provide_return_value, true)

  defp put_provide_return_value(message, _), do: message
end
