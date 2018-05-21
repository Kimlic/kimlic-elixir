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

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Core.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:quorum, in_umbrella: true},
      {:phoenix, "~> 1.3.2"},
      {:cowboy, "~> 1.1"},
      {:swoosh, "~> 0.14"},
      {:redix, ">= 0.0.0"},
      {:jsonrpc2, "~> 1.0"},
      {:shackle, "~> 0.5"}, # tcp client for jsonrps2

      {:distillery, "~> 1.5", runtime: false}
    ]
  end
end
