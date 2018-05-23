defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :core,
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

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:quorum, in_umbrella: true},
      {:redix, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:swoosh, "~> 0.14"},
      {:gen_smtp, "~> 0.12.0"}
    ]
  end
end
