defmodule ProxyApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :proxy_api,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ProxyApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:quorum, in_umbrella: true},
      {:phoenix, "~> 1.3.2"},
      {:plug_logger_json, "~> 0.5"},
      {:cowboy, "~> 1.0"}
    ]
  end
end
