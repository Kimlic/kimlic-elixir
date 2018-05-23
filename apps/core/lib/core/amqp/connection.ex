defmodule Core.AMQP.Connection do
  @moduledoc """
  AQMP connection.
  """
  use RBMQ.Connection, otp_app: :core
end