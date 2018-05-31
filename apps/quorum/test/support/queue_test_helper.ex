defmodule Quorum.QueueTestHelper do
  alias AMQP.{Basic, Channel, Queue}
  alias TaskBunny.Queue, as: TaskBunnyQueue

  # Queue Helpers
  def open_channel(host \\ :default) do
    conn = TaskBunny.Connection.get_connection!(host)
    {:ok, _channel} = Channel.open(conn)
  end

  def purge(queue, host \\ :default)

  def purge(queue, host) when is_binary(queue) do
    {:ok, channel} = open_channel(host)

    Queue.purge(channel, queue)
    Queue.delete(channel, queue)

    Channel.close(channel)

    :ok
  end

  def purge_all(queue) do
    Enum.each(TaskBunnyQueue.queue_with_subqueues(queue), &purge(&1))
  end

  def pop(queue) do
    {:ok, channel} = open_channel()

    Basic.qos(channel, prefetch_count: 1)
    Basic.consume(channel, queue)

    receive do
      {:basic_deliver, payload, meta} ->
        Channel.close(channel)
        {payload, meta}
    end
  end

  def fetch_payload_from_queue(queue_data) do
    Jason.decode!(queue_data)["payload"]
  end
end
