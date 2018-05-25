defmodule Quorum.AMQP.Transaction.Consumer do
  @moduledoc """
  Consumer for AQMP work queue.
  """
  use RBMQ.Consumer,
    otp_app: :quorum,
    connection: Quorum.AMQP.Connection

  def consume(payload, tag: tag, redelivered?: _redelivered) do
    payload
    |> Jason.decode!()
    |> IO.inspect()

    System.halt()
  end
end
