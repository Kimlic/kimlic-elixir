defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [
      app: :core,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Core.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:quorum, in_umbrella: true},
      {:phoenix, "~> 1.3.2"},
      {:cowboy, "~> 1.1"},
      {:redix, ">= 0.0.0"},
      {:rbmq, "~> 0.4"},
      {:ranch, "~> 1.5", override: true},
      {:ranch_proxy_protocol, "~> 1.5", override: true},
      {:exjsx, "~> 4.0", override: true},
      {:distillery, "~> 1.5", runtime: false}
    ]
  end
end
