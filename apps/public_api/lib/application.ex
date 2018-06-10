defmodule PublicApi.Application do
  use Application

  @spec start(Application.start_type(), list) :: Supervisor.on_start()
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(PublicApi.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: PublicApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec config_change(term, term, term) :: :ok
  def config_change(changed, _new, removed) do
    PublicApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
