defmodule Quorum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false
  alias Quorum.AMQP.{Connection, Transaction.Producer, Transaction.Consumer}

  def start(_type, _args) do
    children = [
      supervisor(Connection, []),
      supervisor(Transaction.Producer, []),
      supervisor(Transaction.Consumer, [])
    ]

    opts = [strategy: :one_for_one, name: Quorum.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
