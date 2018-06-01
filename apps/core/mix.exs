defmodule Core.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :core,
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
      preferred_cli_env: [coveralls: :test],
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
      {:confex, "~> 3.3.1"},
      {:redix, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:swoosh, "~> 0.14"},
      {:gen_smtp, "~> 0.12.0"},
      {:ex_twilio, "~> 0.6.0"},
      {:mox, "~> 0.3", only: :test}
    ]
  end
end
