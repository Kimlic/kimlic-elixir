defmodule Quorum.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :quorum,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:keccakf1600, "~> 2.0.0"},
      {:jason, "~> 1.0"},
      {:confex, "~> 3.3.1"},
      {:task_bunny, "~> 0.3.2"},
      {:ethereumex, "~> 0.3.2"},
      {:mox, "~> 0.3", only: :test}
    ]
  end
end
