defmodule Quorum.Jobs.TransactionCreate do
  use TaskBunny.Job
  alias Quorum.Jobs.TransactionStatus
  require Logger

  @quorum_client Application.get_env(:quorum, :client)

  @spec perform(map) :: :ok
  def perform(%{"transaction_data" => transaction_data, "callback" => callback}) do
    case @quorum_client.eth_send_transaction(transaction_data, []) do
      {:ok, transaction_hash} ->
        TransactionStatus.enqueue!(%{transaction_hash: transaction_hash, callback: callback})

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
end
