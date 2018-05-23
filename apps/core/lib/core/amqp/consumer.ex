defmodule Core.AMQP.Consumer do
  @moduledoc """
  Consumer for AQMP work queue.
  """
  use RBMQ.Consumer,
      otp_app: :ap_merger,
      connection: Core.AMQP.Connection

  def consume(payload, [tag: tag, redelivered?: _redelivered]) do
    # write a code
#    payload
#    |> Jason.decode!()
  end
end