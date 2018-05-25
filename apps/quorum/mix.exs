defmodule Quorum.MixProject do
  use Mix.Project

  def project do
    [
      app: :quorum,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Quorum.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:confex, "~> 3.3.1", override: true},
      {:rbmq, "~> 0.4"},
      {:ranch, "~> 1.5", override: true},
      {:ranch_proxy_protocol, "~> 1.5", override: true},
      {:exjsx, "~> 4.0", override: true}
    ]
  end
end
