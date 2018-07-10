defmodule AttestationApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :attestation_api,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {AttestationApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:quorum, in_umbrella: true},
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:httpoison, "~> 1.2", override: true},
      {:jason, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:plug_logger_json, "~> 0.5"},
      {:ecto, "~> 2.2"},
      {:postgrex, ">= 0.0.0"},
      {:eview, "~> 0.12"},
      {:pigeon, "~> 1.2.0"},
      {:kadabra, "~> 0.4.2"},
      {:mox, "~> 0.3", only: :test},
      {:ex_machina, "~> 2.2", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ]
    ]
  end
end
