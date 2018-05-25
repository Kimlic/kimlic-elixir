defmodule Quorum.AMQP.Connection do
  @moduledoc """
  AQMP connection.
  """
  use RBMQ.Connection, otp_app: :quorum
end
