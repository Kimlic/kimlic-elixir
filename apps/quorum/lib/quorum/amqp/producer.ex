defmodule Quorum.AMQP.Producer do
  @moduledoc """
  Mock Producer for testing
  """
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      # for Idle producer create simple GenServer
      if :quorum |> Confex.fetch_env!(__MODULE__) |> Keyword.get(:idle) do
        use GenServer
        use Confex, opts

        def start_link do
          GenServer.start_link(__MODULE__, config(), name: __MODULE__)
        end

        def publish(data) do
          GenServer.call(__MODULE__, {:publish, data})
        end

        def get_messages(amount \\ 1) do
          GenServer.call(__MODULE__, {:get_messages, amount})
        end

        def status do
          GenServer.call(__MODULE__, :status)
        end

        def purge do
          GenServer.cast(__MODULE__, :purge)
        end

        def init(conf) do
          {:ok, {conf[:queue][:name], []}}
        end

        def handle_call({:publish, data}, _from, {queue, queue_data}) do
          {:reply, :ok, {queue, List.insert_at(queue_data, -1, data)}}
        end

        def handle_call({:get_messages, _amount}, _from, {queue, [head | tail]} = state) do
          {:reply, {:ok, Jason.encode!(head), %{message_count: length(tail), queue: queue}},
           {queue, tail}}
        end

        def handle_call({:get_messages, _amount}, _from, {queue, _} = state) do
          {:reply, {:ok, nil, %{message_count: 0, queue: queue}}, state}
        end

        def handle_call(:status, _from, {queue, queue_data} = state) do
          {:reply, {:ok, %{message_count: length(queue_data), queue: queue}}, state}
        end

        def handle_cast(:purge, {queue, _}) do
          {:noreply, {queue, []}}
        end
      else
        # use real Rbmq
        use RBMQ.Producer, opts
      end
    end
  end
end
