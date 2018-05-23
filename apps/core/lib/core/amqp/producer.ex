defmodule Core.AMQP.Producer do
  @moduledoc """
  Producer to submit data to Assets.Out queue.
  """
#  use Core.AMQP.MockProducer,
  use RBMQ.Producer,
      otp_app: :core,
      connection: Core.AMQP.Connection
end