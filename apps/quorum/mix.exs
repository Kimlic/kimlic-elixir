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
      elixirc_paths: elixirc_paths(Mix.env()),
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
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
      {:jason, "~> 1.0"},
      {:task_bunny, "~> 0.3.2"},
      {:ethereumex, "~> 0.3.2"},
      {:mox, "~> 0.3", only: :test}
    ]
  end
end
