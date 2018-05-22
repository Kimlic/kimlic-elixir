defmodule Core.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(CoreWeb.Endpoint, []),
      %{
        id: Redix,
        start: {Redix, :start_link, [Application.get_env(:core, Redix), [name: :redix]]}
      }
    ]

    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
