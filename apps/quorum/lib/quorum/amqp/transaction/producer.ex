defmodule Quorum.AMQP.Transaction.Producer do
  @moduledoc """
  Producer to submit data to Assets.Out queue.
  """
  #  use Quorum.AMQP.MockProducer,
  use RBMQ.Producer,
    otp_app: :quorum,
    connection: Quorum.AMQP.Connection
end
