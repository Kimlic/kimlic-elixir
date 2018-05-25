defmodule Quorum.QueueTestHelper do
  alias AMQP.{Basic, Channel, Connection, Queue}

  defmacro clean(queues) do
    quote do
      # Remove pre-existing queues before every test.
      {:ok, connection} = Connection.open()
      {:ok, channel} = Channel.open(connection)

      Enum.each(unquote(queues), fn queue -> Queue.delete(channel, queue) end)

      on_exit(fn ->
        # Cleanup after test by removing queue.
        Enum.each(unquote(queues), fn queue -> Queue.delete(channel, queue) end)
        Connection.close(connection)
      end)
    end
  end

  # Queue Helpers
  def open_channel(host \\ :default) do
    conn = TaskBunny.Connection.get_connection!(host)
    {:ok, _channel} = Channel.open(conn)
  end

  def declare(queue, host \\ :default) do
    {:ok, channel} = open_channel(host)
    {:ok, _state} = Queue.declare(channel, queue, durable: true)

    Channel.close(channel)

    :ok
  end

  def purge(queue, host \\ :default)

  def purge(queue, host) when is_binary(queue) do
    {:ok, channel} = open_channel(host)

    Queue.purge(channel, queue)
    Queue.delete(channel, queue)

    Channel.close(channel)

    :ok
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
end
