defmodule FidoQrCode.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      FidoQrCode.Repo
    ]

    opts = [strategy: :one_for_one, name: FidoQrCode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
