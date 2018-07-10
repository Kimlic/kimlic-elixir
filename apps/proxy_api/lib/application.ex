defmodule ProxyApi.Application do
  use Application

  @spec start(Application.start_type(), list) :: {:error, term} | {:ok, pid} | {:ok, pid, term}
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(ProxyApi.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: ProxyApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec config_change(term, term, term) :: :ok
  def config_change(changed, _new, removed) do
    ProxyApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
