defmodule MobileApi.Mixfile do
  use Mix.Project

  @version "0.19.0"

  def project do
    [
      app: :mobile_api,
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
      deps: deps()
    ]
  end

  def application do
    [
      mod: {MobileApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:core, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:confex, "~> 3.3.1"},
      {:phoenix, "~> 1.3.2"},
      {:plug_logger_json, "~> 0.5"},
      {:cowboy, "~> 1.0"}
    ]
  end
end
