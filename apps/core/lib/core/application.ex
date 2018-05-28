defmodule Core.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      %{
        id: Redix,
        start: {Redix, :start_link, [Application.get_env(:core, Redix), [name: :redix]]}
      }
    ]

    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
