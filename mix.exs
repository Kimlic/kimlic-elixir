defmodule Kimlic.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        ignore_warnings: "config/.dialyzer_ignore",
        plt_file: {:no_warn, "priv/dialyxir_erlang-20.3.6_elixir-1.6.5.plt"}
      ]
    ]
  end

  defp deps do
    [
      {:distillery, "~> 1.5", runtime: false},
      {:excoveralls, "~> 0.9", only: [:dev, :test]},
      {:credo, "~> 0.9.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false}
    ]
  end
end
